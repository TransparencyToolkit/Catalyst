class CreateAnnotators < ActiveRecord::Migration[4.2]
  def change
    create_table :annotators do |t|
      t.string :name
      t.string :icon
      t.string :description
      t.text :input_params
      t.string :classname
      t.string :output_fields

      t.timestamps null: false
    end
  end
end
