class AddOffsetsToAnnotations < ActiveRecord::Migration[8.0]
  def change
    add_column :annotations, :start_offset, :integer
    add_column :annotations, :end_offset, :integer
    add_column :annotations, :selection_text, :text
    remove_column :annotations, :before_context, :string
    remove_column :annotations, :after_context, :string
    remove_column :annotations, :fragment, :string
  end
end
