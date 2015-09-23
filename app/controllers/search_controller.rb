class SearchController < ApplicationController

  def index
    #show a list of products w/o reviews
    @products = ProductParser.call(params[:q])
  end

  def results
    #shows the review based on what the user clicks
    @product = Product.find(params[:product][:id])
    @reviews = ReviewParser.call(@product.asin, @product.id)
    @dasbhoard = dashboard_text
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

    {
      best_sentence: best_sentence.high_sentence,
      worst_sentence: worst_sentence.low_sentence,
      best_review: best_review.content,
      worst_review: worst_review.content
    }
  end

  def item_params
    params.require(:product).permit(:id)
  end
end
