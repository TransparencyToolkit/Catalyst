# Generate recipes by chaining together annotators
module RecipeGen
  # Generate and run recipe
  def prepare_recipe(annotators, index_name, default_dataspec)
    # Train all machine learning classifiers
    train_all_classifiers(annotators)

    # Generate block for each annotator in recipe
    annotator_blocks = Array.new
    annotators.each do |annotator_params|
      annotator_blocks.push(prepare_annotator(annotator_params, index_name, default_dataspec))
    end

    # Generate recipe block for complete recipe
    return generate_recipe_block(annotator_blocks, index_name)
  end
  
  # Generate a recipe block from all of the annotator blocks
  def generate_recipe_block(annotator_blocks, index_name)
    return lambda do |doc|
      # Gen block to run each annotator on the doc, take output of last as input of next
      doc = annotator_blocks.inject(doc) do |doc, annotator_block|
        doc = annotator_block.call(doc)
      end

      return doc
    end
  end
end
