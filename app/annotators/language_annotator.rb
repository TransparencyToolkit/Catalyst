# Detects the language of a document
class LanguageAnnotator
  def initialize(output_field_name, fields_to_check)
    @fields_to_check = fields_to_check
    @output_field_name = output_field_name
  end

  # Check language in doc
  def gen_language_block
    return lambda do |doc|
      language = Array.new
      @fields_to_check.each do |field|
        field_text = doc["_source"][field]

        # Detect language
        language_hash = CLD.detect_language(field_text)

        # Filter out uncertain results
        if language_hash[:reliable] && language_hash[:name].downcase != "tg_unknown_language"
          found_language = language_hash[:name].downcase.capitalize
        else
          found_language = "Undetermined"
        end
        language.push(found_language)
      end

      # Save in appropriate field
      doc["_source"][@output_field_name] = language
      return doc
    end
  end

  # Initialize block to call
  def gen_block
    return gen_language_block
  end
end
