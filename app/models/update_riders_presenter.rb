class UpdateRidersPresenter
  attr_reader :div_id, :race_class

  def initialize(div_id, race_class)
    @div_id = div_id
    @race_class = race_class
  end

  def series
    @_series ||= race_class.series
  end
end
