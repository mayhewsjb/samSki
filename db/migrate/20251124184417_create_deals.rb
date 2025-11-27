class CreateDeals < ActiveRecord::Migration[8.0]
  def change
    create_table :deals do |t|
      t.string :url
      t.string :description
      t.integer :position

      t.timestamps
    end
  end
end
