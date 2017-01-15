
### Simple RPG class structure to enable object loading
class RPG
end

class RPG::EventCommand
	def initialize(code = 0, indent = 0, parameters = [])
		@code = code
		@indent = indent
		@parameters = parameters
	end

	attr_accessor :code
	attr_accessor :indent
	attr_accessor :parameters
end

class RPG::AudioFile
	def initialize(name = '', volume = 100, pitch = 100)
		@name = name
		@volume = volume
		@pitch = pitch
	end

	attr_accessor :name
	attr_accessor :volume
	attr_accessor :pitch
end

class RPG::SE < RPG::AudioFile
end

class RPG::BGM < RPG::AudioFile
end

class RPG::BGS < RPG::AudioFile
end

class RPG::ME < RPG::AudioFile
end

class RPG::MoveRoute
	def initialize
		@repeat = true
		@skippable = false
		@wait = false
		@list = [RPG::MoveCommand.new]
	end

	attr_accessor :repeat
	attr_accessor :skippable
	attr_accessor :wait
	attr_accessor :list
end


class RPG::MoveCommand
	def initialize(code = 0, parameters = [])
		@code = code
		@parameters = parameters
	end

	attr_accessor :code
	attr_accessor :parameters
end

module FinalClass
end

class Scene_File
end

class Scene_MenuBase
end

class Window_Selectable
end

def rpgvxace?
	return true
end

### From the RPG Maker documentation
def load_data(filename)
	if not File.exist?(filename)
		puts "Error: File: #{filename} does not exist."
		return nil
	end

	File.open(filename, "rb") { |f| return Marshal.load(f) }
end

### From the RPG Maker documentation
def save_data(obj, filename)
	File.open(filename, "wb") { |f| Marshal.dump(obj, f) }
end
