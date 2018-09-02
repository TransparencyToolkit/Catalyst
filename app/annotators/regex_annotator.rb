# Extracts matches to a regular expression
class RegexAnnotator
  include RegexUtils
  def initialize(output_field_name, fields_to_check, output_display_type, regex)
    @fields_to_check = fields_to_check
    @output_field_name = output_field_name
    @regex = regex
  end

  # Extract matches to the regex
  def gen_regex_block
    return lambda do |doc|
      regex_matches = Array.new
      
      @fields_to_check.each do |field|
        # Get text to check, don't downcase if case_sensitive true
        field_text = doc["_source"][field]

        # Get matches to regex
        if field_text
          regex_matches += run_regex(field_text, @regex)
        end
      end
      
      # Save in appropriate field
      doc["_source"][@output_field_name] = regex_matches.uniq
      return doc
    end
  end

  # Initialize block to call
  def gen_block
    return gen_regex_block
  end
end
