require 'nokogiri'
require 'open-uri'

class AWSReviewParser
  BASE_URL = "http://www.amazon.com"
  PAGE_NUMBER = 1


  def self.parse_reviews(item_id)
    url = "#{BASE_URL}/product-reviews/#{item_id}?pageNumber=#{PAGE_NUMBER}"
    page = Nokogiri::HTML(open(url))
    page.css('div.reviews div.review').map do |r|
      {
        id: r['id'],
        date: r.css('span.review-date').text.scan(/[^on]/).join('').strip,
        rating: r.css('i.review-rating').text,
        votes: r.css('span.review-votes').text,
        author: r.css('a.author').text,
        title: r.css('a.review-title').text,
        content: r.css('span.review-text').text,
        author_url: BASE_URL + r.css('a.author').first['href'],
        review_url: BASE_URL + r.css('a.review-title').first['href']
      }
    end
  end
end
