require_relative 'equipItem'

class RPG::Armor < RPG::EquipItem
  def initialize
    super
    @atype_id = 0
    @etype_id = 1
    @features.push(RPG::BaseItem::Feature.new(22, 1, 0))
  end

	def getDiff(obj)
		diffs = super
		diffs << "Armor Type ID changed" if @atype_id != obj.atype_id
		return diffs
	end

  def performance
    params[3] + params[5] + params.inject(0) {|r, v| r += v }
  end
  attr_accessor :atype_id
end