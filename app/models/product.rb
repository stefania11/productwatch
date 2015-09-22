class Product < ActiveRecord::Base
  has_many :reviews
  has_many :authors, through: :reviews

  attr_accessor :id, :title, :image_url
end
