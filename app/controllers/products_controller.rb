class ProductsController < ApplicationController
  def index
    @products = ProductParser.call(product_params[:q])
  end

  def show
    @product = Product.find(params[:id])
    @reviews = ReviewParser.call(@product.asin, @product.id)
    @dashboard = Product.dashboard_text(@product)
    @chart_data = Product.get_chart_data(@product.reviews)
    @chart = Product.create_chart(@chart_data)
  end

  def author_data
  end

  private

  def product_params
    params.require(:product).permit(:q)
  end
end
