class RoundsController < ApplicationController
  load_and_authorize_resource
  
  def index
  end
  
  def show 
  end
  
  def manage_rounds

    # Round.all.each do |round|
      
    #   round.destroy unless round.series
    #   round.destroy unless round.race_class

    # end
    # RaceClass.all.each do |race_class|
    #   race_class.destroy unless race_class.series      
    # end
    current_user.licenses.each do |license|
      license.destroy if license.licensable.nil? || license.licensable.race_class.nil?      
    end

    @licenses = current_user.licenses
    @race_classes = current_user.race_classes 
    
    # @race_classes = current_user.race_classes
    
  end

end
