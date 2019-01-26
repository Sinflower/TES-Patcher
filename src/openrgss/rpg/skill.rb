require_relative 'usableItem'

class RPG::Skill < RPG::UsableItem
	def initialize
		super
		@scope = 1
		@stype_id = 1
		@mp_cost = 0
		@tp_cost = 0
		@message1 = ''
		@message2 = ''
		@required_wtype_id1 = 0
		@required_wtype_id2 = 0
	end
	
	def getDiff(obj)
		diffs = super
		diffs << "Type changed" if @stype_id != obj.stype_id
		diffs << "MP Cost changed" if @mp_cost != obj.mp_cost
		diffs << "TP Cost changed" if @tp_cost != obj.tp_cost
		diffs << "Message 1 changed" if @message1 != obj.message1
		diffs << "Message 2 changed" if @message2 != obj.message2
		diffs << "Required Weapon 1 changed" if @required_wtype_id1 != obj.required_wtype_id1
		diffs << "Required Weapon 2 changed" if @required_wtype_id2 != obj.required_wtype_id2
		return diffs
	end
	
	attr_accessor :stype_id
	attr_accessor :mp_cost
	attr_accessor :tp_cost
	attr_accessor :message1
	attr_accessor :message2
	attr_accessor :required_wtype_id1
	attr_accessor :required_wtype_id2
end
