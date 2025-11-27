class AddBrokenReportsCountToDeals < ActiveRecord::Migration[8.0]
  def change
    add_column :deals, :broken_reports_count, :integer, default: 0, null: false
  end
end
