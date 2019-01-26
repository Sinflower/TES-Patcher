require_relative 'baseItem'

class RPG::Class < RPG::BaseItem
  def initialize
    super
    @exp_params = [30,20,30,30]
    @params = Table.new(8,100)
    (1..99).each do |i|
      @params[0,i] = 400+i*50
      @params[1,i] = 80+i*10
      (2..5).each {|j| @params[j,i] = 15+i*5/4 }
      (6..7).each {|j| @params[j,i] = 30+i*5/2 }
    end
    @learnings = []
    @features.push(RPG::BaseItem::Feature.new(23, 0, 1))
    @features.push(RPG::BaseItem::Feature.new(22, 0, 0.95))
    @features.push(RPG::BaseItem::Feature.new(22, 1, 0.05))
    @features.push(RPG::BaseItem::Feature.new(22, 2, 0.04))
    @features.push(RPG::BaseItem::Feature.new(41, 1))
    @features.push(RPG::BaseItem::Feature.new(51, 1))
    @features.push(RPG::BaseItem::Feature.new(52, 1))
  end
  def exp_for_level(level)
    lv = level.to_f
    basis = @exp_params[0].to_f
    extra = @exp_params[1].to_f
    acc_a = @exp_params[2].to_f
    acc_b = @exp_params[3].to_f
    return (basis*((lv-1)**(0.9+acc_a/250))*lv*(lv+1)/
      (6+lv**2/50/acc_b)+(lv-1)*extra).round.to_i
  end

	def getDiff(obj)
		diffs = super
		diffs << "EXP Curve changed" if @exp_params != obj.exp_params
		@learnings.each_with_index { | l, idx | diffs += l.getDiff(obj.learnings[idx], idx) }
		return diffs
	end

  attr_accessor :exp_params
  attr_accessor :params
  attr_accessor :learnings
end

class RPG::Class::Learning
  def initialize
    @level = 1
    @skill_id = 1
    @note = ''
  end

	def getDiff(obj, idx)
		diffs = []

		unless(obj)
			diffs << "Learn Skill [#{idx}]: New entry"
			return diffs
		end

		diffs << "Learn Skill [#{idx}]: Level changed" if @level != obj.level
		diffs << "Learn Skill [#{idx}]: Skill ID changed" if @skill_id != obj.skill_id
		diffs << "Learn Skill [#{idx}]: Note changed" if @note != obj.note
		return diffs
	end
	
  attr_accessor :level
  attr_accessor :skill_id
  attr_accessor :note
end
