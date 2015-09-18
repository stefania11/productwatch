require 'AWSProductParser'
class SearchController < ApplicationController
  
  def index
    request = AWSProductParser.build_product_request(params[:q])
    @items = AWSProductParser.get_product_response(request)
  end
  
end
