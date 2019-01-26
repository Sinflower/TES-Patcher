class RPG::Map
	def initialize(width, height)
		@display_name = ''
		@tileset_id = 1
		@width = width
		@height = height
		@scroll_type = 0
		@specify_battleback = false
		@battleback_floor_name = ''
		@battleback_wall_name = ''
		@autoplay_bgm = false
		@bgm = RPG::BGM.new
		@autoplay_bgs = false
		@bgs = RPG::BGS.new('', 80)
		@disable_dashing = false
		@encounter_list = []
		@encounter_step = 30
		@parallax_name = ''
		@parallax_loop_x = false
		@parallax_loop_y = false
		@parallax_sx = 0
		@parallax_sy = 0
		@parallax_show = false
		@note = ''
		@data = Table.new(width, height, 4)
		@events = {}
	end

	def ==(obj)
		return false unless obj
		return false unless @display_name == obj.display_name
		return false unless @tileset_id == obj.tileset_id
		return false unless @width == obj.width
		return false unless @height == obj.height
		return false unless @scroll_type == obj.scroll_type
		return false unless @specify_battleback == obj.specify_battleback
		return false unless @battleback1_name == obj.battleback1_name
		return false unless @battleback2_name == obj.battleback2_name
		return false unless @autoplay_bgm == obj.autoplay_bgm
		return false unless @bgm == obj.bgm
		return false unless @autoplay_bgs == obj.autoplay_bgs
		return false unless @bgs == obj.bgs
		return false unless @disable_dashing == obj.disable_dashing
		return false unless @encounter_list == obj.encounter_list
		return false unless @encounter_step == obj.encounter_step
		return false unless @parallax_name == obj.parallax_name
		return false unless @parallax_loop_x == obj.parallax_loop_x
		return false unless @parallax_loop_y == obj.parallax_loop_y
		return false unless @parallax_sx == obj.parallax_sx
		return false unless @parallax_sy == obj.parallax_sy
		return false unless @parallax_show == obj.parallax_show
		return false unless @note == obj.note
		return false unless @data == obj.data
		return false unless @events == obj.events
		return true
	end

	attr_accessor :display_name
	attr_accessor :tileset_id
	attr_accessor :width
	attr_accessor :height
	attr_accessor :scroll_type
	attr_accessor :specify_battleback
	attr_accessor :battleback1_name
	attr_accessor :battleback2_name
	attr_accessor :autoplay_bgm
	attr_accessor :bgm
	attr_accessor :autoplay_bgs
	attr_accessor :bgs
	attr_accessor :disable_dashing
	attr_accessor :encounter_list
	attr_accessor :encounter_step
	attr_accessor :parallax_name
	attr_accessor :parallax_loop_x
	attr_accessor :parallax_loop_y
	attr_accessor :parallax_sx
	attr_accessor :parallax_sy
	attr_accessor :parallax_show
	attr_accessor :note
	attr_accessor :data
	attr_accessor :events
end

class RPG::Map::Encounter
	def initialize
		@troop_id = 1
		@weight = 10
		@region_set = []
	end

	def ==(obj)
		return false unless obj
		return false unless @troop_id == obj.troop_id
		return false unless @weight == obj.weight
		return false unless @region_set == obj.region_set
		return true
	end

	attr_accessor :troop_id
	attr_accessor :weight
	attr_accessor :region_set
end