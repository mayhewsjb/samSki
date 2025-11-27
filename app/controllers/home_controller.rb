class HomeController < ApplicationController
  # Make the homepage public; everything else stays auth-protected
  allow_unauthenticated_access only: :index

  def index
    @site_status = SiteStatus.first_or_create!(body: "")
    @deals = Deal.order(position: :asc, created_at: :desc)
    @deals_last_updated_at = Deal.maximum(:updated_at)

    @featured_deal = if @site_status.featured_deal_id.present?
      Deal.find_by(id: @site_status.featured_deal_id)
    end
  end
end
