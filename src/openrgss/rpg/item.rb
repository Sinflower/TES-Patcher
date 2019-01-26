require_relative 'usableItem'

class RPG::Item < RPG::UsableItem
	def initialize
		super
		@scope = 7
		@itype_id = 1
		@price = 0
		@consumable = true
	end
	def key_item?
		@itype_id == 2
	end

	def getDiff(obj)
		diffs = super
		diffs << "Item Type ID changed" if @itype_id != obj.itype_id
		diffs << "Price changed" if @price != obj.price
		diffs << "Consumable changed" if @consumable != obj.consumable
		return diffs
	end

	attr_accessor :itype_id
	attr_accessor :price
	attr_accessor :consumable
end
