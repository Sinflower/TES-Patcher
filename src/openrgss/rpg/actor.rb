require_relative 'baseItem'

class RPG::Actor < RPG::BaseItem
  def initialize
    super
    @nickname = ''
    @class_id = 1
    @initial_level = 1
    @max_level = 99
    @character_name = ''
    @character_index = 0
    @face_name = ''
    @face_index = 0
    @equips = [0,0,0,0,0]
  end

	def getDiff(obj)
		diffs = super
		diffs << "Nickname changed" if @nickname != obj.nickname
		diffs << "Class ID changed" if @class_id != obj.class_id
		diffs << "Initial Level changed" if @initial_level != obj.initial_level
		diffs << "Max Level changed" if @max_level != obj.max_level
		diffs << "Character Picture Name changed" if @character_name != obj.character_name
		diffs << "Character Picture Index changed" if @character_index != obj.character_index
		diffs << "Face Picture Name changed" if @face_name != obj.face_name
		diffs << "Face Picture Index changed" if @face_index != obj.face_index
		@equips.each_with_index { | eq, idx | diffs << "Equip [#{idx}] changed" if eq != obj.equips[idx] }
		return diffs
	end

  attr_accessor :nickname
  attr_accessor :class_id
  attr_accessor :initial_level
  attr_accessor :max_level
  attr_accessor :character_name
  attr_accessor :character_index
  attr_accessor :face_name
  attr_accessor :face_index
  attr_accessor :equips
end
