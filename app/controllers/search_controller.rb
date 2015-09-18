class SearchController < ApplicationController
  include AWSProductParser
  
  def index
    request = build_product_request(params[:q])
    @items = get_product_response(request)
  end
end
