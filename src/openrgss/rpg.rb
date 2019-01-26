require_relative 'table'
require_relative 'audio'
require_relative 'color'
require_relative 'font'
require_relative 'plane'
require_relative 'rect'
require_relative 'tilemap'
require_relative 'tone'
require_relative 'viewport'

class RPG
end

require_relative 'rpg/actor.rb'
require_relative 'rpg/animation.rb'
require_relative 'rpg/armor.rb'
require_relative 'rpg/audioFile.rb'
require_relative 'rpg/baseItem.rb'
require_relative 'rpg/class.rb'
require_relative 'rpg/commonEvent.rb'
require_relative 'rpg/enemy.rb'
require_relative 'rpg/equipItem.rb'
require_relative 'rpg/event.rb'
require_relative 'rpg/eventCommand.rb'
require_relative 'rpg/item.rb'
require_relative 'rpg/map.rb'
require_relative 'rpg/mapInfo.rb'
require_relative 'rpg/moveCommand.rb'
require_relative 'rpg/moveRoute.rb'
require_relative 'rpg/skill.rb'
require_relative 'rpg/state.rb'
require_relative 'rpg/system.rb'
require_relative 'rpg/tileset.rb'
require_relative 'rpg/troop.rb'
require_relative 'rpg/usableItem.rb'
require_relative 'rpg/weapon.rb'


module FinalClass
end

class Scene_File
end

class Scene_MenuBase
end

class Window_Selectable
end

def rpgvxace?
	return true
end

### From the RPG Maker documentation
def load_data(filename)
	if not File.exist?(filename)
		puts "Error: File: #{filename} does not exist."
		return nil
	end

	File.open(filename, "rb") { |f| return Marshal.load(f) }
end

### From the RPG Maker documentation
def save_data(obj, filename)
	File.open(filename, "wb") { |f| Marshal.dump(obj, f) }
end
