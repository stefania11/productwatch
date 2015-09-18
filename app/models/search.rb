class Search
  def self.for(query)
    Product.where("name LIKE ?", "%#{query}%")
  end
end
