class AddTrainerToAnnotators < ActiveRecord::Migration
  def change
    add_column :annotators, :trainer, :string
  end
end
