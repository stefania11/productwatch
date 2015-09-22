module ProductParser
  def self.build_results_hash(query)
    request = self.build_product_request(query)
    products = self.get_product_response(request)
    list_of_products = products['Items']['Item']
    list_of_products.map do |product|
      if product['CustomerReviews']['HasReviews'] == 'true'
        p = Product.new
        p.id = product['ASIN']
        p.title = product['ItemAttributes']['Title']
        p.image_url = get_image(product)
        p.save
        p
      end
    end
  end

  def self.build_product_request(query)
    # initialize sucker gem
    request = Sucker.new(
      :key    => ENV['AWS_ACCESS_KEY_ID'],
      :secret => ENV['AWS_SECRET_ACCESS_KEY'],
      :associate_tag => 'tag',
      :locale => :us
    )
    # build request
    request << {
      :operation     => 'ItemSearch',
      :keywords      => query,
      :search_index  => 'All',
      :ResponseGroup => 'Small,Images,Reviews',
      :ItemPage      => 1
    }
    request
  end

  def self.get_product_response(request)
    response = request.get
    products = response.to_hash
    products
  end

  def self.get_image(product)
    if product['LargeImage']
      return product['LargeImage']['URL']
    else
      return 'default.jpg'
    end
  end
end
