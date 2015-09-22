class Author < ActiveRecord::Base
  belongs_to :product, through: :reviews
end
