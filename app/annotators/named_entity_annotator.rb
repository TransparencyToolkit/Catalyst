# Extracts names of people, organizations, and locations
class NamedEntityAnnotator
  def initialize(output_field_name, fields_to_check, entity_type)
    @fields_to_check = fields_to_check
    @output_field_name = output_field_name
    @entity_type = entity_type
  end

  # Detect entities
  def gen_entities_block
    return lambda do |doc|
      entities_list = Array.new
      @fields_to_check.each do |field|
        text_nohtml = Nokogiri::HTML.parse(doc["_source"][field]).text.gsub(/\s+/, ' ')

        # Send text to NER server
        client = TCPSocket.open('localhost', 9002)
        client.puts(text_nohtml)
        
        # Save response
        response = ""
        while line = client.gets
          response += line
        end
        client.close_read
        
        entities_list += Nokogiri::HTML(response).css(@entity_type).map{|t| t.text}
      end

      # Save and return
      doc["_source"][@output_field_name] = entities_list.uniq
      return doc
    end
  end

  # Initialize the block to call
  def gen_block
    return gen_entities_block
  end
end
