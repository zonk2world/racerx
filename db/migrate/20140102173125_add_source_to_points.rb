class AddSourceToPoints < ActiveRecord::Migration
  def change
    add_reference :points, :source, polymorphic: true, index: true
  end
end
