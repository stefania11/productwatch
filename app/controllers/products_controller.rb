class ProductsController < ApplicationController
  def index
    @products = ProductParser.call(params[:q])
  end

  def show
    @product = Product.find(params[:id])
    @reviews = ReviewParser.call(@product.asin, @product.id)
    @map_data = build_map_data
    binding.pry
    @dashboard = dashboard_text
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
    h = Hash.new(0)
    @reviews.each do |review|
      # h[review.author.location] = average
      review.author.map do |author|
        review.rating.first.to_i
      end
      # h[review.author.location].map { |k, v| k,v.to_s }
      # h[review.author.location] = h[review.author.location].reduce(:+)
    end
  end

  def item_params
    params.require(:product).permit(:id)
  end
end
