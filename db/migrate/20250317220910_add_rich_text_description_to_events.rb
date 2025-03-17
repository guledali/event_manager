class AddRichTextDescriptionToEvents < ActiveRecord::Migration[8.0]
  def change
    change_table :events do |t|
      t.remove :description if column_exists?(:events, :description)
    end
  end
end
