class ProductsController < ApplicationController
  def index
    @products = ProductParser.call(params[:q])
  end

  def show
    @product = Product.find(params[:id])
    @reviews = ReviewParser.call(@product.asin, @product.id)
    # @map_data = build_map_data
    @dashboard = dashboard_text

    # chart stuff
    @graph_data = get_graph_data
    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.chart(type: 'areaspline')
      f.title(text: 'Average Rating Over Time')
      f.xAxis(categories: @graph_data[:years])
      f.yAxis(title: {text: 'Rating', margin: 50})
      f.series(name: 'Average Rating', data: @graph_data[:ratings])
      f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
    end
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
    h = Hash.new(0)
    @reviews.each { |r| h[r.author.location] += r.rating.first.to_f }
    h.each { |k, v| h[k] = v / 30 }
  end

  def get_graph_data
    avg_rtg_per_year = Hash.new(0)
    num_rtg_per_year = Hash.new(0)
    formatted_data = {years: [], ratings: []}

    @reviews.each { |r| avg_rtg_per_year[r.date.year] += r.rating.first.to_f }
    @reviews.each { |r| num_rtg_per_year[r.date.year] += 1 }

    avg_rtg_per_year.each do |k, v|
      avg_rtg_per_year[k] = (v / num_rtg_per_year[k].to_f).round(2)
    end

    avg_rtg_per_year.sort.each do |r|
      formatted_data[:years] << r.first
      formatted_data[:ratings] << r.last
    end

    formatted_data
  end

  def item_params
    params.require(:product).permit(:id)
  end
end
