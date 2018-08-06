class Point < ActiveRecord::Base
  belongs_to :pointable, polymorphic: true
  belongs_to :source, polymorphic: true
end
