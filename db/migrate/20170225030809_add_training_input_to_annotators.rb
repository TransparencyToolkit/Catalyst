class AddTrainingInputToAnnotators < ActiveRecord::Migration
  def change
    add_column :annotators, :training_input, :text
  end
end
