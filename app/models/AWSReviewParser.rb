require 'nokogiri'
require 'open-uri'

class AWSReviewParser
  include ::SentimentAnalyzer

  BASE_URL = "http://www.amazon.com"
  NUMBER_OF_PAGES = 3


  def self.parse_reviews(item_id)
    review_array = []
    1.upto(NUMBER_OF_PAGES) do |i|
      url = "#{BASE_URL}/product-reviews/#{item_id}?pageNumber=#{i}"
      page = Nokogiri::HTML(open(url))
      page.css('div.reviews div.review').map do |r|
        sentiment_data = SentimentAnalyzer.sentiment_data(r.css('span.review-text').text)
        review_array << {
          id: r['id'],
          date: r.css('span.review-date').text.scan(/[^on]/).join('').strip,
          rating: r.css('i.review-rating').text,
          votes: r.css('span.review-votes').text,
          author: r.css('a.author').text,
          title: r.css('a.review-title').text,
          content: r.css('span.review-text').text,
          author_url: BASE_URL + r.css('a.author').first['href'],
          review_url: BASE_URL + r.css('a.review-title').first['href'],
          low_sentence: sentiment_data[:low],
          high_sentence: sentiment_data[:high],
          overall_sentiment: sentiment_data[:overall]
        }
      end
    end
    review_array
  end
end
