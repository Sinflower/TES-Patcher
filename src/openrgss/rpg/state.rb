require_relative 'baseItem'

class RPG::State < RPG::BaseItem
  def initialize
    super
    @restriction = 0
    @priority = 50
    @remove_at_battle_end = false
    @remove_by_restriction = false
    @auto_removal_timing = 0
    @min_turns = 1
    @max_turns = 1
    @remove_by_damage = false
    @chance_by_damage = 100
    @remove_by_walking = false
    @steps_to_remove = 100
    @message1 = ''
    @message2 = ''
    @message3 = ''
    @message4 = ''
  end

	def getDiff(obj)
		diffs = super
		diffs << "Restriction changed" if @restriction != obj.restriction
		diffs << "Priority changed" if @priority != obj.priority
		diffs << "Remove at Battle end changed" if @remove_at_battle_end != obj.remove_at_battle_end
		diffs << "Remove by Restriction changed" if @remove_by_restriction != obj.remove_by_restriction
		diffs << "Auto Removal Timing changed" if @auto_removal_timing != obj.auto_removal_timing
		diffs << "Min Turns changed" if @min_turns != obj.min_turns
		diffs << "Max Turns changed" if @max_turns != obj.max_turns
		diffs << "Remove by Damage changed" if @remove_by_damage != obj.remove_by_damage
		diffs << "Chance by Damage changed" if @chance_by_damage != obj.chance_by_damage
		diffs << "Remove by Walking changed" if @remove_by_walking != obj.remove_by_walking
		diffs << "Steps to Remove changed" if @steps_to_remove != obj.steps_to_remove
		diffs << "Message 1 changed" if @message1 != obj.message1
		diffs << "Message 2 changed" if @message2 != obj.message2
		diffs << "Message 3 changed" if @message3 != obj.message3
		diffs << "Message 4 changed" if @message4 != obj.message4
		return diffs
	end

  attr_accessor :restriction
  attr_accessor :priority
  attr_accessor :remove_at_battle_end
  attr_accessor :remove_by_restriction
  attr_accessor :auto_removal_timing
  attr_accessor :min_turns
  attr_accessor :max_turns
  attr_accessor :remove_by_damage
  attr_accessor :chance_by_damage
  attr_accessor :remove_by_walking
  attr_accessor :steps_to_remove
  attr_accessor :message1
  attr_accessor :message2
  attr_accessor :message3
  attr_accessor :message4
end