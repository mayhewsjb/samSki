class CreateSiteStatuses < ActiveRecord::Migration[8.0]
  def change
    create_table :site_statuses do |t|
      t.text :body

      t.timestamps
    end
  end
end
