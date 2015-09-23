require 'nokogiri'
require 'open-uri'

module ReviewParser
  include SentimentAnalyzer
  include ProfileParser

  BASE_URL = "http://www.amazon.com"
  NUMBER_OF_PAGES = 3

  def self.call(product_asin, product_db_id)
    review_array = []
    1.upto(NUMBER_OF_PAGES) do |i|
      url = "#{BASE_URL}/product-reviews/#{product_asin}?pageNumber=#{i}"
      page = Nokogiri::HTML(open(url, 'User-Agent' => 'chrome'))
      page.css('div.reviews div.review').map do |r|
        sentiment_data = SentimentAnalyzer.sentiment_data(r.css('span.review-text').text)
        author_url = BASE_URL + html_path_from_nokogiri(r,'a.author')
        review_array <<
          @r = Review.new
          @r.title = r.css('a.review-title').text
          @r.content = r.css('span.review-text').text
          @r.rating = r.css('i.review-rating').text
          @r.date = r.css('span.review-date').text.to_date
          @r.votes = r.css('span.review-votes').text
          @r.low_sentence = sentiment_data[:low]
          @r.low_score = sentiment_data[:low_score]
          @r.high_sentence = sentiment_data[:high]
          @r.high_score = sentiment_data[:high_score]
          @r.overall_sentiment = sentiment_data[:overall]
          @r.overall_score = sentiment_data[:overall_score]
          @r.product_id = product_db_id
          @r.save
          #@r.create_author(
            #name: r.css('a.author').text,
            #url: author_url,
            #location: ProfileParser.get_author_location(author_url)
          #)
          @r
      end
    end
    review_array
  end

  private

  def self.html_path_from_nokogiri(r,tag)
    if r.css(tag).first
      return r.css(tag).first['href']
    else
      return "/"
    end
  end

end
