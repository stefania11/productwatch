class SearchController < ApplicationController

  def index
    #show a list of products w/o reviews
    @products = ProductParser.call(params[:q])
  end

  def results
    #shows the review based on what the user clicks
    @product = params[:product]
    @product[:reviews] = ReviewParser.call(params[:product][:id])
  end

  private

  def item_params
    params.require(:product).permit(:id, :title, :image_url)
  end
end
