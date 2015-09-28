module ProductParser
  NUMBER_OF_PAGES = 5

  def self.call(query)
    product_objects = []
    products_hash_array = []
    1.upto(NUMBER_OF_PAGES) do |page|
      products_hash_array << self.get_product_data(query, page)
    end
    products_hash_array.each do |products|
      begin
        list_of_products = products['ItemSearchResponse']['Items']['Item']
        product_objects << list_of_products.map do |product|
          if product['CustomerReviews']['HasReviews'] == 'true'
            Product.new.tap do |p|
              p.asin = product['ASIN']
              p.title = product['ItemAttributes']['Title']
              p.image_url = get_image(product)
              p.price = get_price(product)
              p.product_group = product['ItemAttributes']['ProductGroup']
              p.manufacturer = product['ItemAttributes']['Manufacturer']
              p.save
            end
          end
        end
      rescue
        return []
      end
    end
    product_objects.flatten
  end

  private

  def self.get_product_data(query, page)
    request = Vacuum.new
    request.configure(
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      associate_tag: 'tag'
    )
    response = request.item_search(
      query: {
        'Keywords' => query,
        'SearchIndex' => 'All',
        'ResponseGroup' => 'Small,Images,Reviews,Offers',
        'ItemPage'      => page,
      }
    )
    response.to_h
  end

  def self.get_image(product)
    begin
      product['LargeImage']['URL']
    rescue Exception
      return 'default.jpg'
    end
  end

  def self.get_price(product)
    begin
      product['Offers']['Offer']['OfferListing']['Price']['FormattedPrice'].scan(/[^$,]/).join.to_f
    rescue Exception
      return 0
    end
  end
end
