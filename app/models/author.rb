class Author < ActiveRecord::Base
  has_many :reviews, dependent: :destroy
end
