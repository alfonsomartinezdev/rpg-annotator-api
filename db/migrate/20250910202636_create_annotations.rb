class CreateAnnotations < ActiveRecord::Migration[8.0]
  def change
    create_table :annotations do |t|
      t.references :document, null: false, foreign_key: true
      t.text :fragment
      t.text :before_context
      t.text :after_context
      t.text :annotation_text
      t.string :author

      t.timestamps
    end
  end
end
