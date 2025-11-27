class AddFeaturedDealToSiteStatuses < ActiveRecord::Migration[8.0]
  def change
    add_column :site_statuses, :featured_deal_id, :integer
  end
end
