class ProductsController < ApplicationController
  def index
    # set up
    @request = Sucker.new(
      :key    => ENV['AWS_ACCESS_KEY_ID'],
      :secret => ENV['AWS_SECRET_ACCESS_KEY'],
      :associate_tag => 'tag',
      :locale => :us
    )

    # build a request
    @request << {
      :operation     => 'ItemSearch',
      :keywords      => 'iphone 6',
      :search_index  => 'All',
      # :brand         => 'Samsung',
      :ResponseGroup => 'Large',
      :TruncateReviewsAt => 0
    }

    # get a response
    @response = @request.get

    # extract specific data
    @response.code == 200 ? @items = @response.to_hash : @items = 'No results found.'
    @response_code = @response.code
  end

  def show
  end
end
