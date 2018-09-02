class CreateAnnotators < ActiveRecord::Migration[4.2]
  def change
    create_table :annotators do |t|
      t.string :name
      t.string :default_icon
      t.string :default_human_readable_label
      t.string :description
      t.text :input_params
      t.string :classname
      t.string :output_display_type

      t.timestamps null: false
    end
  end
end
