# Identifies keywords based on word composition, word length, and frequency
class HighscoreAnnotator
  def initialize(output_field_name, fields_to_check, number_of_keywords)
    @fields_to_check = fields_to_check
    @output_field_name = output_field_name
    @number_of_keywords = number_of_keywords
  end

  # Calculate keywords
  def gen_highscore_block
    return lambda do |doc|
      keywords = Array.new
      @fields_to_check.each do |field|
        field_text = doc["_source"][field]
        keywords += field_text.keywords.top(@number_of_keywords).map{|k| k.text}
      end

      # Save in appropriate field
      doc["_source"][@output_field_name["catalyst_highscore"]] = keywords.uniq
      return doc
    end
  end

  # Initialize block to call
  def gen_block
    return gen_highscore_block
  end
end
