# Extracts phone numbers. Works with all countries, but not all local #s
class PhoneAnnotator
  include RegexUtils
  def initialize(output_field_name, fields_to_check)
    @fields_to_check = fields_to_check
    @output_field_name = output_field_name
  end

  # Check if date is a valid number
  def is_valid_date?(number)
    begin
      Date.parse(number)
      return true
    rescue
      return false
    end
  end

  # Checks if the number is a valid phone number
  def is_valid_phone_num?(number)
    GlobalPhone.validate(number) ? (return true) : (return false)
  end

  # Extract phone numbers
  def gen_phone_block
    return lambda do |doc|
      phone_matches = Array.new
      
      @fields_to_check.each do |field|
        # Get text to check
        field_text = doc["_source"][field]

        # Get possible phone matches
        phone_regex = '(?<=\W)[\d\+][\d|-| ]{5,}\d(?=\W)'
        possible_phone_nums = run_regex(field_text, phone_regex)

        # Filter for phone numbers that are not dates and are valid phone #s
        phone_matches += possible_phone_nums.select{|num| !is_valid_date?(num)}.select{|num| is_valid_phone_num?(num)}
      end
      
      # Save in appropriate field
      doc["_source"][@output_field_name] = phone_matches.uniq
      return doc
    end
  end

  # Initialize block to call
  def gen_block
    return gen_phone_block
  end
end
