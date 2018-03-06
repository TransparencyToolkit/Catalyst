# Generates the block to run the annotator
module AnnotatorGen
  # Pull together all the pieces needed to gen annotator block
  def prepare_annotator(annotator_params)
    annotator_details = get_annotator_details(annotator_params["annotator_name"])

    # Get input and output parameters
    params_for_annotator = [list_output_field_names(annotator_details, annotator_params)]
    params_for_annotator = list_annotator_inputs(annotator_details, annotator_params, params_for_annotator)

    # Return the annotator block
    return get_annotator_block(annotator_details, params_for_annotator)
  end
  
  # Get block returned by annotator
  def get_annotator_block(annotator_details, params_for_annotator)
    annotator_block_gen = Module.const_get(annotator_details.classname).new(*params_for_annotator)
    return annotator_block_gen.gen_block
  end
  
  # Generate a list of output field names
  def list_output_field_names(annotator_details, annotator_params)
    output_field_names = Hash.new
    annotator_details.output_fields.each do |output_field|
      output_field_names[output_field] = annotator_params["output_param_names"][output_field]
    end
    return output_field_names
  end

  # Generate input parameters for annotator
  def list_annotator_inputs(annotator_details, annotator_params, params_for_annotator)
    params_input_vals = annotator_params["input_params"]
    annotator_details.input_params.each do |input_param|
      params_for_annotator.push(params_input_vals[input_param[0].to_s])
    end
    return params_for_annotator
  end
  
  # Get the annotator details in the JSON
  def get_annotator_details(annotator_name)
    return Annotator.find_by(classname: annotator_name)
  end
end
