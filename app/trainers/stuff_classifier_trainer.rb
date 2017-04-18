# Trainer for the stuff classifier gem
class StuffClassifierTrainer
  include ParseTrainingData
  def initialize(training_data, label, classifier_algorithm)
    # Parse training data
    @training_data = parse_from_file_with_docs(training_data)
    
    # Setup classifier to use appropriate algorithm
    if classifier_algorithm == "naive_bayes"
      @classifier = StuffClassifier::Bayes.new(label)
    elsif classifier_algorithm == "tfidf"
      @classifier = StuffClassifier::TfIdf.new(label)
    end
  end

  # Train and save the data
  def train
    @training_data.each do |item|
      @classifier.train(item[:label], item[:data])
    end
    
    @classifier.save_state
  end
end
