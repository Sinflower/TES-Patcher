class RPG::Animation
  def initialize
    @id = 0
    @name = ''
    @animation1_name = ''
    @animation1_hue = 0
    @animation2_name = ''
    @animation2_hue = 0
    @position = 1
    @frame_max = 1
    @frames = [RPG::Animation::Frame.new]
    @timings = []
  end
  def to_screen?
    @position == 3
  end
  attr_accessor :id
  attr_accessor :name
  attr_accessor :animation1_name
  attr_accessor :animation1_hue
  attr_accessor :animation2_name
  attr_accessor :animation2_hue
  attr_accessor :position
  attr_accessor :frame_max
  attr_accessor :frames
  attr_accessor :timings
end

class RPG::Animation::Frame
  def initialize
    @cell_max = 0
    @cell_data = Table.new(0, 0)
  end
  attr_accessor :cell_max
  attr_accessor :cell_data
end

class RPG::Animation::Timing
  def initialize
    @frame = 0
    @se = RPG::SE.new('', 80)
    @flash_scope = 0
    @flash_color = Color.new(255,255,255,255)
    @flash_duration = 5
  end
  attr_accessor :frame
  attr_accessor :se
  attr_accessor :flash_scope
  attr_accessor :flash_color
  attr_accessor :flash_duration
end
