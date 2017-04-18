# Identifies keywords using Rapid Automatic Keyword Extraction (RAKE)
class RakeAnnotator
  def initialize(output_field_name, fields_to_check, number_of_keywords)
    @fields_to_check = fields_to_check
    @output_field_name = output_field_name
    @number_of_keywords = number_of_keywords
  end

  # Calculate keywords
  def gen_rake_block
    return lambda do |doc|
      keywords = Array.new
      @fields_to_check.each do |field|
        field_text = doc["_source"][field]

        # Extract keywords
        rake = RakeText.new
        all_keywords = rake.analyse(field_text, RakeText.SMART)

        # Filter and return
        selected_keywords = all_keywords.sort_by{|k, v| v}.select{|k, v| v>1 && v<8}.select{|k, v| k.length < 20}
        selected_keywords = selected_keywords.reverse[0...@number_of_keywords]
        keywords += selected_keywords.map{|k, v| k.gsub("\n", '')}
      end

      # Save in appropriate field
      doc["_source"][@output_field_name["catalyst_rake"]] = keywords.uniq
      return doc
    end
  end

  # Initialize block to call
  def gen_block
    return gen_rake_block
  end
end