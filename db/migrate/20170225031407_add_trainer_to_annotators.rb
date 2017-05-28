class AddTrainerToAnnotators < ActiveRecord::Migration[4.2]
  def change
    add_column :annotators, :trainer, :string
  end
end
