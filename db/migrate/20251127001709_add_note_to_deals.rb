class AddNoteToDeals < ActiveRecord::Migration[8.0]
  def change
    add_column :deals, :note, :text
  end
end
