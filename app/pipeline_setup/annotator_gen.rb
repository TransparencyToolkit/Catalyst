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

  # If field name is not set, use default
  def set_human_readable_fieldname(annotator_details, annotator_params)
    if annotator_params["output_param_name"]
      return annotator_params["output_param_name"]
    else # Use the default if none set
      return annotator_details.default_human_readable_label
    end
  end

  # If field icon is not set, use default
  def set_field_icon(annotator_details, annotator_params)
    if annotator_params["output_param_icon"]
      return annotator_params["output_param_icon"].to_s
    else # Use the default icon if none set
      return annotator_details.default_icon
    end
  end

  # Set the display type for the field
  def set_display_type(annotator_details, annotator_params)
    display_type = annotator_details.output_display_type

    # In some cases the display type is set by the user from a dropdown
    if display_type == "Set By User"
     return  annotator_params["input_params"]["output_display_type"]
    else # This is what is done in most cases
      return display_type
    end
  end

  # Set a machine readable param name
  def gen_machine_readable_param(field_hash)
    return "catalyst_"+field_hash[:human_readable].strip.downcase.gsub(" ", "_").gsub("-", "_")
  end
  
  # Generate a list of output field names
  def add_output_field_to_dataspec(annotator_details, annotator_params, project_index, doc_class)
    # Generate the params to pass to generate the field
    field_hash = {
      display_type: set_display_type(annotator_details, annotator_params), 
      icon: set_field_icon(annotator_details, annotator_params),
      human_readable: set_human_readable_fieldname(annotator_details, annotator_params)
    }
    machine_readable_param = gen_machine_readable_param(field_hash)

    # Add a field to the dataspec and return param
    add_field(doc_class, project_index, machine_readable_param, field_hash)
    return machine_readable_param
  end

  # Generate input parameters for annotator
  def list_annotator_inputs(annotator_details, annotator_params, params_for_annotator)
    # Add fields to check array to args array
    params_for_annotator.push(annotator_params["fields_to_check"])
    
    # Add user-supplied input values to args array
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
