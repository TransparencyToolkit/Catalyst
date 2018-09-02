class Annotator < ActiveRecord::Base
  validates_presence_of :name,
                        :classname,
                        :description,
                        :default_human_readable_label,
                        :output_display_type
  serialize :input_params, Hash
end
