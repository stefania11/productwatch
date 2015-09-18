module AWSProductParser
  def build_product_request(keyword)
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
      :keywords      => keyword,
      :search_index  => 'All',
      :ResponseGroup => 'Large',
      :TruncateReviewsAt => 0
    }
    request
  end

  def get_product_response(request)
    response = request.get
    response.to_hash
  end
end
