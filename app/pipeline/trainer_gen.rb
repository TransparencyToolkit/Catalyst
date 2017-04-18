# Train machine learning algorithms
module TrainerGen
  # Train classifiers and return classifiers
  def train_all_classifiers(annotator_params)
    # Get all annotators where trainer is not nil
    annotators_to_train = annotator_params.select{|d| get_annotator_details(d["annotator_name"])["trainer"]}

    # Run trainer for all annotators with a trainer
    annotators_to_train.each do |annotator|
      gen_trainer(annotator)
    end
  end

  # Generate and train an individual trainer for a given annotator
  def gen_trainer(annotator)
    trainer_details = get_annotator_details(annotator["annotator_name"])

    # Get the class and params
    trainer_class = trainer_details["trainer"]
    trainer_params = get_trainer_input_params(trainer_details, annotator)

    # Run the trainer
    train_trainer(trainer_class, trainer_params)
  end

  # Train the trainer that is input
  def train_trainer(trainer_class, trainer_params)
    trainer = eval "#{trainer_class}.new(*#{trainer_params})"
    trainer.train
  end

  # Gets the list of input params for the trainer
  def get_trainer_input_params(trainer_details, annotator)
    return trainer_details["training_input"].inject([]) do |trainer_params, input_field|
      trainer_params.push(annotator["training_input"][input_field[0].to_s])
    end
  end
end
