class Annotator < ActiveRecord::Base
  validates_presence_of :name, :icon, :description, :input_params, :classname, :output_type
  serialize :input_params, Hash
  serialize :training_input, Hash
end
