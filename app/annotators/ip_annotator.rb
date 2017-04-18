# Extracts IP addresses
class IpAnnotator
  include RegexUtils
  def initialize(output_field_name, fields_to_check)
    @fields_to_check = fields_to_check
    @output_field_name = output_field_name
  end

  # Extract IPs
  def gen_ip_block
    return lambda do |doc|
      ip_matches = Array.new
      
      @fields_to_check.each do |field|
        # Get text to check
        field_text = doc["_source"][field]

        # Run regex
        ipv4_regex = '(?<=\W)\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}(?=\W)'
        ipv6_regex = '(?<=\W)(?:[0-9A-Fa-f]{0,4}[:]){5,7}(?:[0-9A-Fa-f]{0,4})(?=\W)'
        ip_matches += run_regex(field_text, ipv4_regex)
        ip_matches += run_regex(field_text, ipv6_regex)
      end
      
      # Save in appropriate field
      doc["_source"][@output_field_name["catalyst_ip"]] = ip_matches.uniq
      return doc
    end
  end

  # Initialize block to call
  def gen_block
    return gen_ip_block
  end
end
