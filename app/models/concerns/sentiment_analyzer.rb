require 'sentimental'

module SentimentAnalyzer

  Sentimental.load_defaults
  Sentimental.threshold = 0.1

  def self.overall_sentiment(text)
    analyzer = Sentimental.new
    analyzer.get_sentiment(text)
  end

  def self.overall_score(text)
    analyzer = Sentimental.new
    analyzer.get_score(text)
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
    return { high: "", low: "", overall: ""} if text == ""

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

    high[0] = high[0] + "." unless high[0][-1,1] == '.' || high[0][-1,1] == '!'
    low[0] = low[0] + "." unless low[0][-1,1] == '.' || high[0][-1,1] == '!'

    {
      high: high[0],
      high_score: high[1],
      low: low[0],
      low_score: low[0],
      overall: overall_sentiment(text).to_s + ".",
      overall_score: get_score
    }

  end


end
