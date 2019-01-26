class RPG::Troop
  def initialize
    @id = 0
    @name = ''
    @members = []
    @pages = [RPG::Troop::Page.new]
  end

	def getDiff(obj)
		diffs = []
		diffs << "ID changed" if @id != obj.id
		diffs << "Name changed" if @name != obj.name
		@members.each_with_index { | m, idx | diffs += m.getDiff(obj.members[idx], idx) }
		@pages.each_with_index { | p, idx | diffs += p.getDiff(obj.pages[idx], idx) }
		return diffs
	end

  attr_accessor :id
  attr_accessor :name
  attr_accessor :members
  attr_accessor :pages
end

class RPG::Troop::Member
  def initialize
    @enemy_id = 1
    @x = 0
    @y = 0
    @hidden = false
  end

	def getDiff(obj, idx)
		diffs = []

		unless(obj)
			diffs << "Troop Member [#{idx}]: New entry"
			return diffs
		end

		diffs << "Troop Member [#{idx}]: Enemy ID changed" if @enemy_id != obj.enemy_id
		diffs << "Troop Member [#{idx}]: X changed" if @x != obj.x
		diffs << "Troop Member [#{idx}]: Y changed" if @y != obj.y
		diffs << "Troop Member [#{idx}]: Hidden changed" if @hidden != obj.hidden
		return diffs
	end

  attr_accessor :enemy_id
  attr_accessor :x
  attr_accessor :y
  attr_accessor :hidden
end

class RPG::Troop::Page
  def initialize
    @condition = RPG::Troop::Page::Condition.new
    @span = 0
    @list = [RPG::EventCommand.new]
  end

	def getDiff(obj, idx)
		diffs = []

		unless(obj)
			diffs << "Troop Page [#{idx}]: New entry"
			return diffs
		end

		diffs += @condition.getDiff(obj.condition, idx)
		diffs << "Troop Page [#{idx}]: Span changed" if @span != obj.span
		diffs << "Troop Page [#{idx}]: Event changed" unless @list == obj.list
		return diffs
	end

  attr_accessor :condition
  attr_accessor :span
  attr_accessor :list
end

class RPG::Troop::Page::Condition
  def initialize
    @turn_ending = false
    @turn_valid = false
    @enemy_valid = false
    @actor_valid = false
    @switch_valid = false
    @turn_a = 0
    @turn_b = 0
    @enemy_index = 0
    @enemy_hp = 50
    @actor_id = 1
    @actor_hp = 50
    @switch_id = 1
  end

	def getDiff(obj, idx)
		diffs = []
		diffs << "Troop Page [#{idx}] Condition: Turn Ending changed" if @turn_ending != obj.turn_ending
		diffs << "Troop Page [#{idx}] Condition: Turn Valid changed" if @turn_valid != obj.turn_valid
		diffs << "Troop Page [#{idx}] Condition: Enemy Valid changed" if @enemy_valid != obj.enemy_valid
		diffs << "Troop Page [#{idx}] Condition: Actor Valid changed" if @actor_valid != obj.actor_valid
		diffs << "Troop Page [#{idx}] Condition: Switch Valid changed" if @switch_valid != obj.switch_valid
		diffs << "Troop Page [#{idx}] Condition: Turn A changed" if @turn_a != obj.turn_a
		diffs << "Troop Page [#{idx}] Condition: Turn B changed" if @turn_b != obj.turn_b
		diffs << "Troop Page [#{idx}] Condition: Enemy Index changed" if @enemy_index != obj.enemy_index
		diffs << "Troop Page [#{idx}] Condition: Enemy HP changed" if @enemy_hp != obj.enemy_hp
		diffs << "Troop Page [#{idx}] Condition: Actor ID changed" if @actor_id != obj.actor_id
		diffs << "Troop Page [#{idx}] Condition: Actor HP changed" if @actor_hp != obj.actor_hp
		diffs << "Troop Page [#{idx}] Condition: Switch ID changed" if @switch_id != obj.switch_id
		return diffs
	end

  attr_accessor :turn_ending
  attr_accessor :turn_valid
  attr_accessor :enemy_valid
  attr_accessor :actor_valid
  attr_accessor :switch_valid
  attr_accessor :turn_a
  attr_accessor :turn_b
  attr_accessor :enemy_index
  attr_accessor :enemy_hp
  attr_accessor :actor_id
  attr_accessor :actor_hp
  attr_accessor :switch_id
end
