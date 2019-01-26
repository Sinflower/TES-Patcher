require_relative 'equipItem'

class RPG::Weapon < RPG::EquipItem
	def initialize
		super
		@wtype_id = 0
		@animation_id = 0
		@features.push(RPG::BaseItem::Feature.new(31, 1, 0))
		@features.push(RPG::BaseItem::Feature.new(22, 0, 0))
	end

	def getDiff(obj)
		diffs = super
		diffs << "Weapon Type ID changed" if @wtype_id != obj.wtype_id
		diffs << "Animation ID changed" if @animation_id != obj.animation_id
		return diffs
	end

	def performance
		params[2] + params[4] + params.inject(0) {|r, v| r += v }
	end
	attr_accessor :wtype_id
	attr_accessor :animation_id
end