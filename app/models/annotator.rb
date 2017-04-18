class Annotator < ActiveRecord::Base
  validates_presence_of :name, :icon, :description, :input_params, :classname, :output_fields
  serialize :input_params, Hash
  serialize :output_fields, Array
  serialize :training_input, Hash
end
