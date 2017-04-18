# Classifies the documents into positive, negative, and neutral sentiment
class SentimentAnnotator
  def initialize(output_field_name, fields_to_check)
    @fields_to_check = fields_to_check
    @output_field_name = output_field_name
  end

  # Calculate sentiment score
  def gen_sentiment_block
    return lambda do |doc|
      sentiment = Array.new
      @fields_to_check.each do |field|
        field_text = doc["_source"][field] 
        sentiment.push(SENTIMENT_ANALYZER.sentiment(field_text).to_s)
      end

      # Save in appropriate field
      doc["_source"][@output_field_name["catalyst_sentiment"]] = sentiment
      return doc
    end
  end

  # Initialize block to call
  def gen_block
    return gen_sentiment_block
  end
end
