require_relative 'baseItem'

class RPG::EquipItem < RPG::BaseItem
	def initialize
		super
		@price = 0
		@etype_id = 0
		@params = [0] * 8
	end

	def getDiff(obj)
		diffs = super
		diffs << "Damage Price changed" if @price != obj.price
		diffs << "Damage Equip Type ID changed" if @etype_id != obj.etype_id
		@params.each_with_index { | p, idx | diffs << "Parameter [#{idx}] changed" if p != obj.params[idx] }
		return diffs
	end

	attr_accessor :price
	attr_accessor :etype_id
	attr_accessor :params
end