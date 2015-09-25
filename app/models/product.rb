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

  def self.get_sentiment_chart_data(reviews)
    sentiment = {positive: 0,
                 negative: 0}

    reviews.each do |review|
      if review.overall_sentiment == "positive."
        sentiment[:positive] +=1
      else
        sentiment[:negative] +=1
      end
    end
    sentiment
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


  def self.create_sentiment_chart(chart_data)
    LazyHighCharts::HighChart.new('graph') do |f|
      f.chart(type: 'column')
      f.title(text: 'Sentiment analyzer for top 30 reviews')
      f.xAxis(categories: ["positive","negative"])
      f.yAxis(title: {text: 'Sentiment Count', margin: 50}, startOnTick: true, endOnTick: true)
      f.series(name: 'Sentiment Count', data: [chart_data[:negative], chart_data[:positive]])
      f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
    end
  end

  def self.create_sentiment_pie_chart(chart_data)
    LazyHighCharts::HighChart.new('graph') do |f|
      f.chart(type: 'pie')
      f.title(text: 'Sentiment analyzer for top 30 reviews')
      f.plotOptions(pie: {dataLabels: {enabled: false}, showInLegend: true})
      f.series({
               :type=> 'pie',
               :name=> 'Sentiment Count',
               :data=> [
                  ['positive', chart_data[:positive]],
                  ['negative', chart_data[:negative]]
               ]
      })
      f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
    end
  end
end
