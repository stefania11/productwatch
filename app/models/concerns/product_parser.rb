module ProductParser
  def self.call(query)
    products = self.get_product_data(query)
    list_of_products = products['ItemSearchResponse']['Items']['Item']
    if list_of_products
      list_of_products.map do |product|
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
    else
      []
    end
  end

  private

  def self.get_product_data(query)
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
        'ItemPage'      => 1
      }
    )
    response.to_h
  end

  def self.get_image(product)
    if product['LargeImage']
      return product['LargeImage']['URL']
    else
      return 'default.jpg'
    end
  end

  
  def self.get_price(product)
    if product['Offers']
      if product['Offers']['Offer']
        return product['Offers']['Offer']['OfferListing']['Price']['FormattedPrice'].scan(/[^$,]/).join.to_f
      else
        return 'n/a'
      end
    else
      return 'n/a'
    end
  end
  
end
