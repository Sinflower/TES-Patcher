class RPG::CommonEvent
	def initialize
		@id = 0
		@name = ""
		@trigger = 0
		@switch_id = 1
		@list = [RPG::EventCommand.new]
	end

	def getDiff(obj)
		diffs = []
		diffs << "ID changed" if @id != obj.id
		diffs << "Name changed" if @name != obj.name
		diffs << "Trigger changed" if @trigger != obj.trigger
		diffs << "Switch ID changed" if @switch_id != obj.switch_id
		diffs << "Event changed" unless @list == obj.list
		return diffs
	end

	attr_accessor :id
	attr_accessor :name
	attr_accessor :trigger
	attr_accessor :switch_id
	attr_accessor :list
end
