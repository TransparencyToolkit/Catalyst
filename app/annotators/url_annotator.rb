require "twitter-text"

# Extracts URLs
class UrlAnnotator
  include Twitter::Extractor
  def initialize(output_field_name, fields_to_check)
    @fields_to_check = fields_to_check
    @output_field_name = output_field_name
  end

  # Extract URLs
  def gen_url_block
    return lambda do |doc|
      url_matches = Array.new
      
      @fields_to_check.each do |field|
        # Get text to check
        field_text = doc["_source"][field]

        # Extract URLs
        url_matches += extract_urls(field_text)
      end
      
      # Save in appropriate field
      doc["_source"][@output_field_name["catalyst_url"]] = url_matches.uniq
      return doc
    end
  end

  # Initialize block to call
  def gen_block
    return gen_url_block
  end
end
