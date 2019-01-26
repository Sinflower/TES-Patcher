class RPG::EventCommand
	def initialize(code = 0, indent = 0, parameters = [])
		@code = code
		@indent = indent
		@parameters = parameters
	end

	def ==(obj)
		return false unless obj
		return false unless @code == obj.code
		return false unless @indent == obj.indent
		return false unless @parameters == obj.parameters
		return true
	end

	attr_accessor :code
	attr_accessor :indent
	attr_accessor :parameters
end
