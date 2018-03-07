class CatalystController < ApplicationController
  include AnnotatorGen
  include RecipeGen
  include TrainerGen
  
  # Run annotators
  def annotate
    # Get index, dataspec names, and docs to run on
    index_name = params["index"]
    default_dataspec = params["default_dataspec"]
    docs_to_process = JSON.parse(params["docs_to_process"])

    # Get list of annotators and generate recipe block
    annotators = JSON.parse(params["input-params"])
    recipe_block = prepare_recipe(annotators, index_name, default_dataspec)
    
    # Query the documents
    QueryDocs.new(index_name, default_dataspec, docs_to_process, recipe_block)
  end

  # Get the info for specific annotator
  def get_annotator_info
    @annotator = get_annotator_details(params[:annotator])
    render json: JSON.pretty_generate(@annotator.attributes)
  end

  # List all available annotators
  def list_annotators
    annotator_list = Annotator.all.inject([]) {|arr, c| arr << c.attributes}
    render json: JSON.pretty_generate(annotator_list)
  end
end
