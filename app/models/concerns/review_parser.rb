require 'nokogiri'
require 'open-uri'

module ReviewParser
  include SentimentAnalyzer
  include ProfileParser

  BASE_URL = "http://www.amazon.com"
  NUMBER_OF_PAGES = 5

  def self.call(product_asin, product_db_id)
    review_array = []
    1.upto(NUMBER_OF_PAGES) do |i|
      url = "#{BASE_URL}/product-reviews/#{product_asin}?pageNumber=#{i}"
      page = Nokogiri::HTML(open(url, 'User-Agent' => 'chrome'))
      page.css('div.reviews div.review').map do |review|
        sentiment_data = SentimentAnalyzer.sentiment_data(review.css('span.review-text').text)
        author_url = BASE_URL + html_path_from_nokogiri(review,'a.author')
        review_array <<
          Review.new.tap do |r|
            r.title = review.css('a.review-title').text
            r.content = review.css('span.review-text').text
            r.rating = review.css('i.review-rating').text
            r.date = review.css('span.review-date').text.to_date
            r.votes = review.css('span.review-votes').text
            r.low_sentence = sentiment_data[:low]
            r.low_score = sentiment_data[:low_score]
            r.high_sentence = sentiment_data[:high]
            r.high_score = sentiment_data[:high_score]
            r.overall_sentiment = sentiment_data[:overall]
            r.overall_score = sentiment_data[:overall_score]
            r.product_id = product_db_id
            r.author_url = author_url
            r.author_name = review.css('a.author').text
            r.save
          end
      end
    end
    review_array
  end

  private

  def self.html_path_from_nokogiri(r,tag)
    begin
      r.css(tag).first['href']
    rescue Exception
      return "/"
    end
  end
end
