require 'sentimental'
require 'pry'

class SentimentAnalyzer

  Sentimental.load_defaults
  Sentimental.threshold = 0.1

  def self.overall_sentiment(text)
    analyzer = Sentimental.new
    analyzer.get_sentiment(text)
  end


  def self.sentiment_of_sentences(text)
    analyzer = Sentimental.new
    sentences_hash = {}
    sentences = text.split(/\. |! /)
    sentences.each do |sentence|
      sentences_hash[sentence]=analyzer.get_score(sentence) 
    end
    sentences_hash
  end

  def self.sentiment_data(text)
    text_with_sentiment = sentiment_of_sentences(text)
    low = text_with_sentiment.first
    high = text_with_sentiment.first
    text_with_sentiment.each do |key,value|
      if value > high[1]
        high = [key,value]
      elsif value < low[1]
        low = [key, value]
      end
    end

    {
      high: high[0],
      low: low[0],
      overall: overall_sentiment(text)
    }

  end
  
  binding.pry
  

end
