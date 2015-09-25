class ProductsController < ApplicationController
  def index
    @products = ProductParser.call(params[:q])
  end

  def show
    @product = Product.find(params[:id])
    @reviews = ReviewParser.call(@product.asin, @product.id)
    # @map_data = build_map_data
    # @map_data = {
    #   AL: 0.333333333333333,
    #   AR: 0.56666666666666666,
    #   CO: 1.16666666666666666,
    #   IN: 1.03333333333333333,
    #   NY: 0.76666666666666666,
    #   LA: 0.90,
    #   CT: 0.600,
    #   DE: 0.500
    # }
    @dashboard = dashboard_text

    # chart stuff
    @chart_data = Product.get_chart_data(@reviews)
    @chart = Product.create_chart(@chart_data)
    @chart_sentiment_data = Product.get_sentiment_chart_data(@reviews)
    @chart_sentiment = Product.create_sentiment_chart(@chart_sentiment_data)
    @chart_sentiment_pie = Product.create_sentiment_pie_chart(@chart_sentiment_data)

  end

  def author_data
  end

  private

  def dashboard_text
    best_sentence = @product.reviews.first
    worst_sentence = @product.reviews.first
    best_review = @product.reviews.first
    worst_review = @product.reviews.first

    @product.reviews.each do |review|
      best_sentence = review if review.high_score > best_sentence.high_score
      worst_sentence = review if review.low_score < worst_sentence.low_score
      best_review = review if review.overall_score > best_review.overall_score
      worst_review = review if review.overall_score < worst_review.overall_score
    end

    return {
      best_sentence: best_sentence.high_sentence,
      worst_sentence: worst_sentence.low_sentence,
      best_review: best_review.content,
      worst_review: worst_review.content
    }
  end

  def build_map_data
    rating_hash = Hash.new(0)
    count_hash = Hash.new(0)

    @reviews.each do |review|
      rating_hash[review.author.location] += review.rating.first.to_f
      count_hash[review.author.location] += 1
    end
    rating_hash.each { |k, v| rating_hash[k] = (v / count_hash[k]) / 5 }
    return rating_hash
  end

  def item_params
    params.require(:product).permit(:id)
  end
end
