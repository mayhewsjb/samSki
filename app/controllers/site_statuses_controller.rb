class SiteStatusesController < ApplicationController
  # ApplicationController already includes Authentication and
  # requires authentication for everything except what we mark public.

  def update
    @site_status = SiteStatus.first_or_create!(body: "")

    if @site_status.update(site_status_params)
      redirect_to root_path, notice: "Status updated."
    else
      # Re-render home with errors if you ever add validations
      @deals = Deal.order(position: :asc, created_at: :desc)
      @deals_last_updated_at = Deal.maximum(:updated_at)
      render "home/index", status: :unprocessable_entity
    end
  end

  private

  def site_status_params
    params.require(:site_status).permit(:body, :featured_deal_id)
  end
end
