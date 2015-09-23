class MapController < ApplicationController
  respond_to :html, :js
  def show
    @product = Product.find(params[:id])
    @product.reviews.author.location
  end
end
