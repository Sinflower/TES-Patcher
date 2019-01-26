class RPG::BaseItem
	def initialize
    @id = 0
    @name = ''
    @icon_index = 0
    @description = ''
    @features = []
    @note = ''
	end

	def getDiff(obj)
		diffs = []
		diffs << "ID changed" if @id != obj.id
		diffs << "Name changed" if @name != obj.name
		diffs << "Icon Index changed" if @icon_index != obj.icon_index
		diffs << "Description changed" if @description != obj.description
		@features.each_with_index { | f, idx | diffs += f.getDiff(obj.features[idx], idx) }
		diffs << "Note changed" if @note != obj.note
		return diffs
	end

  attr_accessor :id
  attr_accessor :name
  attr_accessor :icon_index
  attr_accessor :description
  attr_accessor :features
  attr_accessor :note
end

class RPG::BaseItem::Feature
	def initialize(code = 0, data_id = 0, value = 0)
		@code = code
		@data_id = data_id
		@value = value
	end

	def getDiff(obj, idx)
		diffs = []

		unless(obj)
			diffs << "Feature [#{idx}]: New entry"
			return diffs
		end

		diffs << "Feature [#{idx}]: Code changed" if @code != obj.code
		diffs << "Feature [#{idx}]: Data ID changed" if @data_id != obj.data_id
		diffs << "Feature [#{idx}]: Value changed" if @value != obj.value
		return diffs
	end

	attr_accessor :code
	attr_accessor :data_id
	attr_accessor :value
end
