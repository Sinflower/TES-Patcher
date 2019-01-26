class RPG::MoveCommand
	def initialize(code = 0, parameters = [])
		@code = code
		@parameters = parameters
	end

	def ==(obj)
		return false unless obj
		return false unless @code == obj.code
		return false unless @parameters == obj.parameters
		return true
	end

	attr_accessor :code
	attr_accessor :parameters
end

