# Extracts matches to a regular expression
class RegexAnnotator
  include RegexUtils
  def initialize(output_field_name, fields_to_check, regex, case_sensitive)
    @fields_to_check = fields_to_check
    @output_field_name = output_field_name
    @regex = regex
    @case_sensitive = case_sensitive
  end

  # Extract matches to the regex
  def gen_regex_block
    return lambda do |doc|
      regex_matches = Array.new
      
      @fields_to_check.each do |field|
        # Get text to check, don't downcase if case_sensitive true
        field_text = @case_sensitive ? doc["_source"][field] : doc["_source"][field].downcase

        # Get matches to regex
        regex_matches += run_regex(field_text, @regex)
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
