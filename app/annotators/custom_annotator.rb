# Runs the block of code passed in on the doc
class CustomAnnotator
  def initialize(output_field_name, fields_to_check, code_block, type)
    @fields_to_check = fields_to_check
    @output_field_name = output_field_name
    @code_block = code_block
    @type = type
  end

  # Run block of code on field
  def gen_custom_block
    return lambda do |doc|
      custom = Array.new if @type == "array"
      @fields_to_check.each do |field|
        field_text = doc["_source"][field]

        # Handle different input types
        if @type == "array"
          custom.push(eval "#{@code_block}")
        else
          custom = eval "#{@code_block}"
        end
      end

      # Save in appropriate field
      doc["_source"][@output_field_name["catalyst_custom"]] = custom
      return doc
    end
  end

  # Initialize block to call
  def gen_block
    return gen_custom_block
  end
end
