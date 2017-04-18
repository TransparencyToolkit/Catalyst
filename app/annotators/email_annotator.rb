# Extracts email addresses
class EmailAnnotator
  include RegexUtils
  def initialize(output_field_name, fields_to_check)
    @fields_to_check = fields_to_check
    @output_field_name = output_field_name
  end

  # Extract emails
  def gen_email_block
    return lambda do |doc|
      email_matches = Array.new
      
      @fields_to_check.each do |field|
        # Get text to check
        field_text = doc["_source"][field]

        # Run regex
        email_regex = '(?<=(?:\b|\s|>|^))(?:\w|-|\.)+@(?:\w|-|\.)+\.\w+(?<=(?:\b|\s|<|$))'
        email_matches += run_regex(field_text, email_regex)
      end
      
      # Save in appropriate field
      doc["_source"][@output_field_name["catalyst_email"]] = email_matches.uniq
      return doc
    end
  end

  # Initialize block to call
  def gen_block
    return gen_email_block
  end
end
