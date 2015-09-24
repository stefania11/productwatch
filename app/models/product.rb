class Product < ActiveRecord::Base
  has_many :reviews

  def self.get_chart_data(reviews)
    avg_rtg_per_year = Hash.new(0)
    num_rtg_per_year = Hash.new(0)
    formatted_data = {years: [], ratings: []}

    reviews.each { |r| avg_rtg_per_year[r.date.year] += r.rating.first.to_f }
    reviews.each { |r| num_rtg_per_year[r.date.year] += 1 }

    avg_rtg_per_year.each do |k, v|
      avg_rtg_per_year[k] = (v / num_rtg_per_year[k].to_f).round(2)
    end

    avg_rtg_per_year.sort.each do |r|
      formatted_data[:years] << r.first
      formatted_data[:ratings] << r.last
    end

    formatted_data
  end

  def self.create_chart(chart_data)
    LazyHighCharts::HighChart.new('graph') do |f|
      f.chart(type: 'areaspline')
      f.title(text: 'Average Rating Over Time')
      f.xAxis(categories: chart_data[:years])
      f.yAxis(title: {text: 'Rating', margin: 50}, startOnTick: true, endOnTick: true)
      f.series(name: 'Average Rating', data: chart_data[:ratings])
      f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
    end
  end
end
