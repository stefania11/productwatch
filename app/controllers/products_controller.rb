class ProductsController < ApplicationController
  def index
    @products = ProductParser.call(product_params[:q])
  end

  def show
    @product = Product.find(params[:id])
    @reviews = ReviewParser.call(@product.asin, @product.id)
    @dashboard = Product.dashboard_text(@product)
    @chart_data = Product.get_chart_data(@reviews)
    @chart = Product.create_chart(@chart_data)
    @chart_sentiment_data = Product.get_sentiment_chart_data(@reviews)
    @chart_sentiment = Product.create_sentiment_chart(@chart_sentiment_data)
    @chart_sentiment_pie = Product.create_sentiment_pie_chart(@chart_sentiment_data)
  end

  private

  def product_params
    params.require(:product).permit(:q)
  end
end
