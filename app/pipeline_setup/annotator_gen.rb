# Generates the block to run the annotator
module AnnotatorGen
  include DocmanagerAPI
  
  # Pull together all the pieces needed to gen annotator block
  def prepare_annotator(annotator_params, index_name, default_dataspec)
    annotator_details = get_annotator_details(annotator_params["annotator_name"])

    # Get input and output parameters
    params_for_annotator = [add_output_field_to_dataspec(annotator_details, annotator_params, index_name, default_dataspec)]
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
  def add_output_field_to_dataspec(annotator_details, annotator_params, project_index, doc_class)
    # Generate a human readable and machine readable name
    human_readable = annotator_params["output_param_name"]
    output_type = annotator_details.output_type
    machine_readable_param = "catalyst_"+human_readable.strip.downcase.gsub(" ", "_").gsub("-", "_")
    
    # Generate the params to pass to generate the field
    field_hash = {
      display_type: output_type, 
      icon: annotator_params["output_param_icon"].to_s,
      human_readable: human_readable
    }

    # Add a field to the dataspec and return param
    add_field(doc_class, project_index, machine_readable_param, field_hash)
    return machine_readable_param
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
