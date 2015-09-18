class SearchController < ApplicationController
  def index
    @items = Search.for(params[:q])
  end
end
