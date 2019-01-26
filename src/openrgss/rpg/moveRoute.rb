class RPG::MoveRoute
	def initialize
		@repeat = true
		@skippable = false
		@wait = false
		@list = [RPG::MoveCommand.new]
	end

	def ==(obj)
		return false unless obj
		return false unless @repeat == obj.repeat
		return false unless @skippable == obj.skippable
		return false unless @wait == obj.wait
		return false unless @list == obj.list
		return true
	end

	attr_accessor :repeat
	attr_accessor :skippable
	attr_accessor :wait
	attr_accessor :list
end
