class HomeController < ApplicationController
  # Make the homepage public; everything else stays auth-protected
  allow_unauthenticated_access only: :index

  def index
    @site_status = SiteStatus.first_or_create!(body: "")
    @deals = Deal.order(position: :asc, created_at: :desc)
    @deals_last_updated_at = Deal.maximum(:updated_at)
  end
end
