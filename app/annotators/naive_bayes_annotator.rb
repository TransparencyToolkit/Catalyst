# Classifies the documents using Naive Bayes based on training data categories
class NaiveBayesAnnotator
  def initialize(output_field_name, fields_to_check, classifier_name)
    @fields_to_check = fields_to_check
    @output_field_name = output_field_name
    @classifier_name = classifier_name
  end

  # Classify with Naive Bayes
  def gen_classifier_block
    return lambda do |doc|
      labels = Array.new
      StuffClassifier::Bayes.open(@classifier_name) do |classifier|
        # Classify text in each field
        @fields_to_check.each do |field|
          field_text = doc["_source"][field]
          labels.push(classifier.classify(field_text).to_s)
        end
        
        # Save in appropriate field
        doc["_source"][@output_field_name["catalyst_naivebayes"]] = labels
        return doc
      end
    end
  end

  # Initialize block to call
  def gen_block
    return gen_classifier_block
  end
end
