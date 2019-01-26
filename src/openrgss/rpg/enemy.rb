require_relative 'baseItem'

class RPG::Enemy < RPG::BaseItem
  def initialize
    super
    @battler_name = ''
    @battler_hue = 0
    @params = [100,0,10,10,10,10,10,10]
    @exp = 0
    @gold = 0
    @drop_items = Array.new(3) { RPG::Enemy::DropItem.new }
    @actions = [RPG::Enemy::Action.new]
    @features.push(RPG::BaseItem::Feature.new(22, 0, 0.95))
    @features.push(RPG::BaseItem::Feature.new(22, 1, 0.05))
    @features.push(RPG::BaseItem::Feature.new(31, 1, 0))
  end

	def getDiff(obj)
		diffs = super
		diffs << "Battler Name changed" if @battler_name != obj.battler_name
		diffs << "Battler Hue changed" if @battler_hue != obj.battler_hue
		@params.each_with_index { | p, idx | diffs << "Parameter [#{idx}] changed" if p != obj.params[idx] }
		diffs << "EXP changed" if @exp != obj.exp
		diffs << "Gold changed" if @gold != obj.gold
		@drop_items.each_with_index { | i, idx | diffs += i.getDiff(obj.drop_items[idx], idx) }
		@actions.each_with_index { | a, idx | diffs += a.getDiff(obj.actions[idx], idx) }
		return diffs
	end

  attr_accessor :battler_name
  attr_accessor :battler_hue
  attr_accessor :params
  attr_accessor :exp
  attr_accessor :gold
  attr_accessor :drop_items
  attr_accessor :actions
end

class RPG::Enemy::DropItem
  def initialize
    @kind = 0
    @data_id = 1
    @denominator = 1
  end

	def getDiff(obj, idx)
		diffs = []

		unless(obj)
			diffs << "DropItem [#{idx}]: New entry"
			return diffs
		end

		diffs << "DropItem [#{idx}]: Kind changed" if @kind != obj.kind
		diffs << "DropItem [#{idx}]: Data ID changed" if @data_id != obj.data_id
		diffs << "DropItem [#{idx}]: Amount changed" if @denominator != obj.denominator
		return diffs
	end

  attr_accessor :kind
  attr_accessor :data_id
  attr_accessor :denominator
end

class RPG::Enemy::Action
  def initialize
    @skill_id = 1
    @condition_type = 0
    @condition_param1 = 0
    @condition_param2 = 0
    @rating = 5
  end
	
	def getDiff(obj, idx)
		diffs = []

		unless(obj)
			diffs << "Action [#{idx}]: New entry"
			return diffs
		end

		diffs << "Action [#{idx}]: Skill ID changed" if @skill_id != obj.skill_id
		diffs << "Action [#{idx}]: Condition Type changed" if @condition_type != obj.condition_type
		diffs << "Action [#{idx}]: Condition Param 1 changed" if @condition_param1 != obj.condition_param1
		diffs << "Action [#{idx}]: Condition Param 2 changed" if @condition_param2 != obj.condition_param2
		diffs << "Action [#{idx}]: Rating changed" if @rating != obj.rating

		diffs.unshift("changed") unless diffs.empty?
		return diffs
	end

  attr_accessor :skill_id
  attr_accessor :condition_type
  attr_accessor :condition_param1
  attr_accessor :condition_param2
  attr_accessor :rating
end
