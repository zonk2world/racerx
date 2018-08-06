class License < ActiveRecord::Base 
  belongs_to :user
  belongs_to :licensable, polymorphic: true

  def race_class
    licensable.race_class
  end
end
