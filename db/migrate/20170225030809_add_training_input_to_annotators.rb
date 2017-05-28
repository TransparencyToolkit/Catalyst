class AddTrainingInputToAnnotators < ActiveRecord::Migration[4.2]
  def change
    add_column :annotators, :training_input, :text
  end
end
