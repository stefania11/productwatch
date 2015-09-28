class Author < ActiveRecord::Base
  has_many :reviews
end
