require_relative 'baseItem'

class RPG::UsableItem < RPG::BaseItem
	def initialize
		super
		@scope = 0
		@occasion = 0
		@speed = 0
		@success_rate = 100
		@repeats = 1
		@tp_gain = 0
		@hit_type = 0
		@animation_id = 0
		@damage = RPG::UsableItem::Damage.new
		@effects = []
	end
	def for_opponent?
		[1, 2, 3, 4, 5, 6].include?(@scope)
	end
	def for_friend?
		[7, 8, 9, 10, 11].include?(@scope)
	end
	def for_dead_friend?
		[9, 10].include?(@scope)
	end
	def for_user?
		@scope == 11
	end
	def for_one?
		[1, 3, 7, 9, 11].include?(@scope)
	end
	def for_random?
		[3, 4, 5, 6].include?(@scope)
	end
	def number_of_targets
		for_random? ? @scope - 2 : 0
	end
	def for_all?
		[2, 8, 10].include?(@scope)
	end
	def need_selection?
		[1, 7, 9].include?(@scope)
	end
	def battle_ok?
		[0, 1].include?(@occasion)
	end
	def menu_ok?
		[0, 2].include?(@occasion)
	end
	def certain?
		@hit_type == 0
	end
	def physical?
		@hit_type == 1
	end
	def magical?
		@hit_type == 2
	end
	
	def getDiff(obj)
		diffs = super
		diffs << "Scope changed" if @scope != obj.scope
		diffs << "Occasion changed" if @occasion != obj.occasion
		diffs << "Speed changed" if @speed != obj.speed
		diffs << "Animation ID changed" if @animation_id != obj.animation_id
		diffs << "Success Rate changed" if @success_rate != obj.success_rate
		diffs << "Repeats changed" if @repeats != obj.repeats
		diffs << "TP Gain changed" if @tp_gain != obj.tp_gain
		diffs << "Hit Type changed" if @hit_type != obj.hit_type
		diffs += @damage.getDiff(obj.damage)
		@effects.each_with_index { | eff, idx | diffs += eff.getDiff(obj.effects[idx], idx) }
		return diffs
	end
	
	attr_accessor :scope
	attr_accessor :occasion
	attr_accessor :speed
	attr_accessor :animation_id
	attr_accessor :success_rate
	attr_accessor :repeats
	attr_accessor :tp_gain
	attr_accessor :hit_type
	attr_accessor :damage
	attr_accessor :effects
end

class RPG::UsableItem::Effect
	def initialize(code = 0, data_id = 0, value1 = 0, value2 = 0)
		@code = code
		@data_id = data_id
		@value1 = value1
		@value2 = value2
	end
	def getDiff(obj, idx)
		diffs = []

		unless(obj)
			diffs << "Effect [#{idx}]: New entry"
			return diffs
		end

		diffs << "Effect [#{idx}]: Code changed" if @code != obj.code
		diffs << "Effect [#{idx}]: Data ID changed" if @data_id != obj.data_id
		diffs << "Effect [#{idx}]: Value 1 changed" if @value1 != obj.value1
		diffs << "Effect [#{idx}]: Value 2 changed" if @value2 != obj.value2
		return diffs
	end
	attr_accessor :code
	attr_accessor :data_id
	attr_accessor :value1
	attr_accessor :value2
end

class RPG::UsableItem::Damage
	def initialize
		@type = 0
		@element_id = 0
		@formula = '0'
		@variance = 20
		@critical = false
	end
	def none?
		@type == 0
	end
	def to_hp?
		[1,3,5].include?(@type)
	end
	def to_mp?
		[2,4,6].include?(@type)
	end
	def recover?
		[3,4].include?(@type)
	end
	def drain?
		[5,6].include?(@type)
	end
	def sign
		recover? ? -1 : 1
	end
	def eval(a, b, v)
		[Kernel.eval(@formula), 0].max * sign rescue 0
	end
	
	def getDiff(obj)
		diffs = []
		diffs << "Damage Type changed" if @type != obj.type
		diffs << "Damage Element ID changed" if @element_id != obj.element_id
		diffs << "Damage Formula changed" if @formula != obj.formula
		diffs << "Damage Variance changed" if @variance != obj.variance
		diffs << "Damage Critical changed" if @critical != obj.critical
		return diffs
	end

	attr_accessor :type
	attr_accessor :element_id
	attr_accessor :formula
	attr_accessor :variance
	attr_accessor :critical
end
