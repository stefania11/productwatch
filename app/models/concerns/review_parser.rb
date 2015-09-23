require 'nokogiri'
require 'open-uri'

module ReviewParser
  include SentimentAnalyzer
  include ProfileParser

  BASE_URL = "http://www.amazon.com"
  NUMBER_OF_PAGES = 3

  def self.call(product_id)
    review_array = []
    1.upto(NUMBER_OF_PAGES) do |i|
      url = "#{BASE_URL}/product-reviews/#{product_id}?pageNumber=#{i}"
      page = Nokogiri::HTML(open(url))
      page.css('div.reviews div.review').map do |r|
        sentiment_data = SentimentAnalyzer.sentiment_data(r.css('span.review-text').text)
        author_url = BASE_URL + html_path_from_nokogiri(r,'a.author')
        # create object and shovel in the array instead
        review_array << {
          id: r['id'],
          date: r.css('span.review-date').text.scan(/[^on]/).join('').strip,
          rating: r.css('i.review-rating').text,
          votes: r.css('span.review-votes').text,
          author: r.css('a.author').text,
          title: r.css('a.review-title').text,
          content: r.css('span.review-text').text,
          author_url: author_url,
          author_location: ProfileParser.get_author_location(author_url),
          review_url: BASE_URL + html_path_from_nokogiri(r,'a.review-title'),
          low_sentence: sentiment_data[:low],
          high_sentence: sentiment_data[:high],
          overall_sentiment: sentiment_data[:overall]
        }
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
