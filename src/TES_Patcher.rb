require 'zlib'
require 'optparse'
require 'win32api'

## credits to https://github.com/zh99998/OpenRGSS/blob/master/lib/openrgss/
require_relative 'openrgss/audio'
require_relative 'openrgss/color'
require_relative 'openrgss/font'
require_relative 'openrgss/plane'
require_relative 'openrgss/rect'
require_relative 'openrgss/table'
require_relative 'openrgss/tilemap'
require_relative 'openrgss/tone'
require_relative 'openrgss/viewport'

require_relative 'openrgss/rpg'
require_relative 'openrgss/eventcodes'

# This is required for the tes code to enable the save functions
$TEST = 1

# Displays the help banner in case no arguments are provided
ARGV << '-h' if ARGV.empty?

$options = {:dumpMain => false, :extract => false, :patch => false, :TrainZ => false,
						:update_inject => false, :maxLength => 50, :eventCodes => nil, :dataDir => nil,
						:extractDir => nil, :patchDir => nil, :printEvtCodes => false}

ARCH_32 = '32-Bit'
ARCH_64 = '64-Bit'

# Calculate Ruby interpreter architecture by looking at pointer size
# 4 bit pointer => 32-Bit
# 8 bit pointer => 64-Bit
ARCH = [''].pack('p').size == 4 ? ARCH_32 : ARCH_64

class Extract_Script
		attr_accessor :scriptName
		attr_accessor :printName
		attr_accessor :found
		attr_accessor :required
		attr_accessor :script

	def initialize(scriptName, printName, required = true, req_arch = nil)
		@scriptName = scriptName
		@printName = printName
		@required = required
		@found = false
		@script = nil
		@req_arch = req_arch
	end

	def checkScriptName(scriptName)
		if @scriptName.kind_of?(Array)
			@scriptName.each do | name |
				return true unless name != scriptName
			end
		else
			return @scriptName == scriptName
		end

		return false
	end

	def ok()
		return true unless not @found
		return true unless @required
		return false
	end

	def load()
		return false unless ok

		if @req_arch && @req_arch != ARCH
			puts "Error: Architecture (#{ARCH}) of ruby interpreter does not match the architecture (#{@req_arch}) required by: #{@printName}."
			return false
		end

		# TODO: Maybe replace with require (problem with ocra and paths)
		# TODO: Add rescue error handling to prevent full crash
		begin
			Object.class_eval @script
		rescue Exception => e
			return true unless @required
			puts "Error: Unable to load: #{@printName}"
			puts e
			return false
		end

		return true
	end

end

module TesPatcher
#************************
#       Variables       *
#************************
	EXTRACT_SCRIPT_NAME = []
	EXTRACT_SCRIPT_NAME << Extract_Script.new("DataManager", "DataManager")
	EXTRACT_SCRIPT_NAME << Extract_Script.new("Game_Interpreter", "Game Interpreter")
	EXTRACT_SCRIPT_NAME << Extract_Script.new("Scene_Base", "Scene Base")
	EXTRACT_SCRIPT_NAME << Extract_Script.new("テキスト→シナリオ変換", "Old-TES Stuff", false)
	EXTRACT_SCRIPT_NAME << Extract_Script.new(["ＴＥＳ本体", "TES本体", "TES基本モジュール"], "TES")
	# Optional script only required when the TES uses the WF_COMP_MODE
	EXTRACT_SCRIPT_NAME << Extract_Script.new("セーブデータ圧縮暗号化スクリプト", "Comp-SaveData", false, ARCH_32)

	## File names / extensions / data dir
	DATA_DIR       = "Data/"
	FILE_EXTENSION = ".rvdata2"
	SCRIPT_NAME    = "Scripts"
	MAIN_NAME      = "main"
	SCRIPT_FULL    = DATA_DIR + SCRIPT_NAME + FILE_EXTENSION

	@main_full     = DATA_DIR + MAIN_NAME   + FILE_EXTENSION

	MAIN_EXTRACT_DIR = "extract_main"
	MAIN_DUMP_DIR    = "dump_main"
	SCRIPT_DUMP_DIR  = "dump_scripts"

	## Event codes
	EVC_TEXT   = 401
	EVC_CHOICE = 408

#************************
#   Private Functions   *
#************************

	def self.loadAdditionals
		EXTRACT_SCRIPT_NAME.each do | n |
			return false unless n.load
		end

		return true
	end

	def self.init
		return nil unless getTESCode

		if not loadAdditionals
			puts "Error: Failed to load external code."
			return nil
		end

		if $options[:dataDir] != nil
			data_dir  = $options[:dataDir]
			@main_full = data_dir + MAIN_NAME + FILE_EXTENSION
		end

		if File.exist?(@main_full)
			print "Decoding #{@main_full} ... "

			# Supress warning messages for ruby >= 2.4.0 due to deprecated code inside the TES code. (https://stackoverflow.com/a/9236504)
			original_verbose, $VERBOSE = $VERBOSE, nil
			events = TesManager::load_tes(data_dir ? data_dir : DATA_DIR, MAIN_NAME)
			# Activate warning messages again.
			$VERBOSE = original_verbose

			puts "done"
			return events
		else
			puts "Error: Unable to find file: #{@main_full}"
			return nil
		end
	end

	def self.decodeScriptCode(c)
		s = Zlib::Inflate.inflate(c).force_encoding('UTF-8')

		############
		# For some reason when reading the scripts every line ends with \r\r\n
		# and for some other reasons I'm unable to replace
		# \r\r -> \r
		# so
		# \r\n -> \n
		# it is
		############
		s.gsub!(/\r\n/) { "\n" }

		return s
	end

	def self.encodeScriptCode(c)
		return Zlib::Deflate.deflate(c)
	end

	###
	#  Extracts the TES code and its requirements from Scripts.rvdata2
	#  and saves them inside the object.
	#  Returns false if not all scripts could be found
	###
	def self.getTESCode
		temp = load_data(SCRIPT_FULL)

		return unless temp != nil

		temp.each do |script|
			EXTRACT_SCRIPT_NAME.each do | n |
				if n.checkScriptName(script[1])
					saveRubyCode(script[2], n)
				end
			end
		end

		EXTRACT_SCRIPT_NAME.each do | n |
			if not n.ok
				puts "#{n.printName} was not found"
				return false
			end
		end

		return true
	end

	def self.getScript(c)
		script = decodeScriptCode(c)
		# This line has to be removed in order for the other encryption process to work
		script.gsub!("@@gle = Win32API.new('kernel32','GetLastError','v','l').freeze") { "\#@@gle = Win32API.new('kernel32','GetLastError','v','l').freeze" }
		# For some reason ruby >= 2.4.0 won't work without a full path to the dll to load
		# TODO: Modify this for cases where the patcher is not in the game base dir 
		script.gsub!("\"wfcrypt\"") { "\"\#{Dir.pwd}/wfcrypt\"" }
		return script
	end
	
	def self.writeCodeToFile(c, filename)
		File.open(filename, 'w') { |file| file.write(getScript(c)) }
	end

	def self.saveRubyCode(c, extractObj)
		puts "Found: #{extractObj.printName} code"
		extractObj.script = getScript(c)
		extractObj.found = extractObj.script != nil
	end

#************************
#    Public Functions   *
#************************

	###
	#  Patches main.rvdata2 by replacing the text strings with
	#  the translated strings from the text files inside
	#  MAIN_EXTRACT_DIR or patchDir. If the translated string is
	#  empty the original text will not be changed
	###
	def self.patch
		events = init
		return unless events

		inputDir = $options[:patchDir] ? $options[:patchDir] : MAIN_EXTRACT_DIR

		if not Dir.exist?(inputDir)
			puts "Patch directory \"#{inputDir}\" does not exist, stopping patching process."
			return
		end

		Dir.glob("#{inputDir}/*.txt") do | file |
			key = File.basename(file, '.*')
			puts "Patching: #{key}"
			o = "" # orignal string
			s = "" # translated string
			i = -1 # id value
			p = -1 # parameter id
			b = false # begin flag

			File.open(file, 'r', :encoding => "BOM|UTF-8").each_line do | line |
				# Remove \n from the end of line
				line.gsub!(/\r\n|\r|\n/) { "" }

				# If the "BEGIN STRING" string is encountered,
				# the next lines will contain the original
				# string, so enter the begin mode by setting
				# b to true and resetting the original string variable
				if line == "> BEGIN STRING"
					b = true
					o = ""
					next
				end

				# If the "END STRING" string is encountered,
				# the current block is over and it is time to evaluate
				# and replace the string
				if line == "> END STRING"
					# Remove newlines from the end of the strings
					s.chomp!
					o.chomp!

					if(p != -1)
						if s == ""
							events[key][i].parameters[p] = o
						else
							events[key][i].parameters[p] = s
						end
					end

					i = -1
					p = -1
					s = ""
					next
				end

				# If a line containing "> EVENT CODE: " is encountered
				# the original string block is over, leave the begin mode
				if line.include? '> EVENT CODE: '
					b = false
					next
				end

				# If a line containing "> VALUE ID: " is encountered
				# the value at which the string is located inside the
				# events array is known
				if line.include? '> VALUE ID: '
					line.slice! '> VALUE ID: '
					i = line.to_i
					next
				end

				# If a line containing "> PARAMETER ID: " is encountered
				# it is known which parameter this entry represents
				if line.include? '> PARAMETER ID: '
					line.slice! '> PARAMETER ID: '
					p = line.to_i
					next
				end

				# If the parameter id (p) is set, the line should contain
				# the translated string, unless the current line is empty
				# it is appended to the string holding the translated string
				s += line + "\n" unless p == -1 || line == ""

				# In the begin mode append the current line
				# together with a newline to the original string value
				o += line + "\n" unless not b
			end
		end

		puts "Patching Successful"

		print "Saving #{MAIN_NAME}#{FILE_EXTENSION} ... "
		TesManager::save_tes(events, "", MAIN_NAME)
		puts "done"
	end

	###
	#  Extracts all text strings from the encoded main.rvdata2
	#  and saves them into text files inside the directory set
	#  in MAIN_EXTRACT_DIR.
	###
	def self.extractMain(additionalEventCodes)
		events = init
		return unless events

		# Create the extraction directory in case it does not exist
		dir = $options[:extractDir] ? $options[:extractDir] : MAIN_EXTRACT_DIR
		Dir.mkdir(dir) unless Dir.exist?(dir)

		codes = []
		codes << EVC_TEXT
		codes << EVC_CHOICE

		# If additional event codes are provided add them to the list
		if additionalEventCodes
			additionalEventCodes.each do | code |
				codes << code.to_s
			end
		end

		events.each do | key, value |
			n = dir + '/' + key + '.txt'

			# Skip if the file already exists
			next unless not File.exist?(n)

			out = File.open(n, 'w')

			out.write '> ANTI TES PATCH FILE VERSION 0.2'

			value.size.times do | i |
				codes.each do | code |
					# Skip the lines just containung the choice end string
					if value[i].code == EVC_CHOICE
						next unless value[i].parameters[0] != "</choice>"
					end

					if value[i].code.to_s == code.to_s
						value[i].parameters.size.times do | j |
							out.puts ''
							out.puts '> BEGIN STRING'
							out.puts value[i].parameters[j]
							out.puts "> EVENT CODE: #{code.to_s}"
							out.puts "> VALUE ID: #{i.to_s}"
							out.puts "> PARAMETER ID: #{j.to_s}"
							out.puts ''
							out.puts '> END STRING'
						end
					end
				end
			end

			out.close

			# Delete the created file if it is empty e.g. it did not contain any text
			File.delete(n) unless not File.zero?(n)
		end

		puts "Extraction Successful"
	end

	###
	#  Dumps each script stored inside Scripts.rvdata2 into
	#  an own file. The files will be stored inside the folder
	#  specified in SCRIPT_DUMP_DIR.
	###
	def self.dumpScript
		# Create the dump directory in case it does not exist
		dir = SCRIPT_DUMP_DIR
		Dir.mkdir(dir) unless Dir.exist?(dir)

		# Load the Scripts file
		temp = load_data(SCRIPT_FULL)

		return unless temp != nil

		puts "Start dumping scripts..."

		cnt = 0

		temp.each do | script |
			script[1].gsub!(/(\<|\>|\:|\"|\/|\\|\||\?|\*)/) {''}
			n = dir + "/" + script[1]
			if not File.exist?(n)
				writeCodeToFile(script[2], n)
				cnt += 1
			end
		end

		puts "Dumping of #{cnt} scripts done."
	end

	###
	# Creates a full dump of all events inside Main.rvdata2
	#
	###
	def self.dumpMain
		events = init
		return unless events

		# Create the extraction directory in case it does not exist
		dir = MAIN_DUMP_DIR
		Dir.mkdir(dir) unless Dir.exist?(dir)

		print "Dumping #{@main_full} ... "

		events.each do | key, value |
			n = dir + '/' + key + '.txt'

			# Skip if the file already exists
			next unless not File.exist?(n)

			out = File.open(n, 'w')

			value.size.times do | i |
				out.puts "EventCode: #{value[i].code}"
				out.puts "Indent: #{value[i].indent}"
				out.puts "Parameter count: #{value[i].parameters.size}"
				out.puts "Parameters:"
				value[i].parameters.size.times do | j |
					out.puts value[i].parameters[j]
				end
				out.puts ''
			end
		end

		puts "done."
	end

	# Not sure why this was removed ... maybe because saving scripts didn't work properly
	# $game_message.add(@list[@index].parameters[0])
	def self.injectLineBreak

		injectString =<<EOF
	tex = @list[@index].parameters[0]
	maxInjectionLineBreakLength = #{$options[:maxLength]}
	if tex.length > maxInjectionLineBreakLength
		while tex.length > maxInjectionLineBreakLength
			spacePos = tex.rindex(" ", maxInjectionLineBreakLength)

			if spacePos == nil
				break
			end

			$game_message.add(tex[0, spacePos]);
			tex = tex[spacePos, tex.length - spacePos];

			if tex[0] == " "
				tex[0] = ''
			end
		end
	else
		$game_message.add(tex)
	end
EOF

		# Load the Scripts file
		temp = load_data(SCRIPT_FULL)

		return unless temp != nil

		print "Patching Scrtipts ... "

		temp.each do | script |
			s = decodeScriptCode(script[2])

			if s.gsub!("$game_message.add(@list[@index].parameters[0])") { injectString } != nil
				script[2] = encodeScriptCode(s)
			end
		end

		save_data(temp, "Scripts_patched")

		puts "done"
	end

	def self.trainZ
		events = init
		return unless events

		events.each do | key, value |
			value.size.times do | i |
				if value[i].code == EVC_TEXT || value[i].code == EVC_CHOICE
					value[i].parameters[0] = "I like TrainZ"
				end
			end
		end

		puts "TrainZing Successful"

		TesManager::save_tes(events, "", MAIN_NAME)
	end

	def self.printEventCodes
		events = init
		return unless events

		codes = {}

		events.each do | key, value |
			value.size.times do | i |
				codes[value[i].code.to_s] = value[i].parameters.size
			end
		end

		# Sort event codes
		codes = codes.sort.to_h

		# Get the longest event code, required for nice printing
		maxCodeLength = codes.keys.max_by(&:length)
		# Get the longest description, required for nice printing
		maxDescriptionLength = EVENT_CODES.values.max_by(&:length)

		puts "Event Codes:"
		printf "%-#{maxCodeLength.length}s %-#{maxDescriptionLength.length}s %s\n", "Code", "Description", "Number of parameters"
		codes.each do | key, value |
			printf "%-#{maxCodeLength.length}s %-#{maxDescriptionLength.length}s %s\n", key.to_s, EVENT_CODES[key.to_s], value.to_s
		end
	end

end

### Add option for
  # Add an additional search name for the TES code - Because of Unicode problems in the cmd add also an option for name loading from file
  # Inject auto line break code into the script code with line length option
  # Update the line length for auto line break

 ## Line break code in case of \N[] is name look up possible? else add static number to string length
  # to compensate for the possibility of the name causing the string to go over length

parser = OptionParser.new do | opts |
	s =<<EOF


▄▄▄█████▓▓█████   ██████
▓  ██▒ ▓▒▓█   ▀ ▒██    ▒
▒ ▓██░ ▒░▒███   ░ ▓██▄
░ ▓██▓ ░ ▒▓█  ▄   ▒   ██▒
  ▒██▒ ░ ░▒████▒▒██████▒▒
  ▒ ░░   ░░ ▒░ ░▒ ▒▓▒ ▒ ░
    ░     ░ ░  ░░ ░▒  ░ ░
  ░         ░   ░  ░  ░
            ░  ░      ░

 ██▓███   ▄▄▄     ▄▄▄█████▓ ▄████▄   ██░ ██ ▓█████  ██▀███
▓██░  ██▒▒████▄   ▓  ██▒ ▓▒▒██▀ ▀█  ▓██░ ██▒▓█   ▀ ▓██ ▒ ██▒
▓██░ ██▓▒▒██  ▀█▄ ▒ ▓██░ ▒░▒▓█    ▄ ▒██▀▀██░▒███   ▓██ ░▄█ ▒
▒██▄█▓▒ ▒░██▄▄▄▄██░ ▓██▓ ░ ▒▓▓▄ ▄██▒░▓█ ░██ ▒▓█  ▄ ▒██▀▀█▄
▒██▒ ░  ░ ▓█   ▓██▒ ▒██▒ ░ ▒ ▓███▀ ░░▓█▒░██▓░▒████▒░██▓ ▒██▒
▒▓▒░ ░  ░ ▒▒   ▓▒█░ ▒ ░░   ░ ░▒ ▒  ░ ▒ ░░▒░▒░░ ▒░ ░░ ▒▓ ░▒▓░
░▒ ░       ▒   ▒▒ ░   ░      ░  ▒    ▒ ░▒░ ░ ░ ░  ░  ░▒ ░ ▒░
░░         ░   ▒    ░      ░         ░  ░░ ░   ░     ░░   ░
               ░  ░        ░ ░       ░  ░  ░   ░  ░   ░


EOF
	s += "Usage: TES_Patcher.exe function [options]"

	opts.banner = s

	opts.separator ""
	opts.separator "Help:"

	opts.on('-h', '--help', 'Displays Help') do
		puts opts
		exit
	end

	opts.separator ""
	opts.separator "Main Functions:"

	opts.on('-e', '--extract [dir]', 'Extracts the event texts from the encoded', 'main.rvdata2 to "dir". If "dir" is not set', 'the default output dir is "extract_main".') do | dir |
		$options[:extract] = true
		$options[:extractDir] = dir
	end

	opts.separator ""

	opts.on('-p', '--patch [dir]', 'Patches main.rvdata2 using the files from', '"dir". If "dir" is not set the default', 'input dir is "extract_main".',
	        'The patched file will be stored in the', 'current directory as:', 'main.rvdata2') do | dir |
		$options[:patch] = true
		$options[:patchDir] = dir
	end

	# opts.separator ""
	# opts.separator "Script Patch Functions:"

	# opts.on('-i', '--inject [maxLength]', 'Injects a line break script into Scripts.rvdata2', 'This will split the text if it\'s length exceeds the given maxLength', 'Defualt: 50') do |maxLength|
		# $options[:maxLength] = maxLength.to_i unless maxLength == nil
		# TesPatcher::injectLineBreak
	# end

	# opts.separator ""

	# opts.on('-u', '--Update [maxLength]', 'Updates the max length for the injected line break script', 'Injects the script if it has not been injected yet', 'Defualt: 50') do |maxLength|
		# $options[:update_inject] = true

		# $options[:maxLength] = maxLength.to_i unless maxLength == nil
	# end

	opts.separator ""
	opts.separator "Options:"

	opts.on('-a', '--add_code code', Array, 'Add additional event codes for the', 'extraction process.', 'Default used codes: 401, 408') do |codes|
		$options[:eventCodes] = codes
	end

	opts.separator ""

	opts.on('-m', '--main_dir dir', 'Changes the search location of', 'main.rvdata2 to "dir".') do |m|
		$options[:dataDir] = m + "/"
	end

	opts.separator ""
	opts.separator "Debug Functions:"

	opts.on('-d', '--dump_script', 'Dump all scripts inside Scripts.rvdata2', 'into separate files.') do
		TesPatcher::dumpScript
	end

	opts.separator ""

	opts.on('-D', '--dump_main', 'Create a full dump of main.rvdata2.') do
		$options[:dumpMain] = true
	end

	opts.separator ""

	opts.on('-c', '--event_codes', 'Prints a list of all event codes used', 'inside main.rvdata2.') do
		$options[:printEvtCodes] = true
	end

	opts.separator ""
	opts.separator "Strange Functions:"

	opts.on('-T', '--TrainZ', 'Replaces EVERY text with:', 'I like TrainZ', 'Yes this will really happen,', 'so do not use this option.',
	                          'YOU HAVE BEEN WARNED', 'Serously don\'t use this, it\'s weird.') do
		$options[:TrainZ] = true
	end
end

parser.parse!

if $options[:extract]
	TesPatcher::extractMain($options[:eventCodes])
end
if $options[:patch]
	TesPatcher::patch
end
if $options[:dumpMain]
	TesPatcher::dumpMain
end
if $options[:printEvtCodes]
	TesPatcher::printEventCodes
end
if $options[:TrainZ]
	TesPatcher::trainZ
end