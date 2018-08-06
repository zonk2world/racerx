class SeriesController < ApplicationController
  load_and_authorize_resource
  
  def index
  end

  def show
    @race_classes = @series.race_classes
  end
end
