class DealsController < ApplicationController
  # All actions here require authentication (by default via Authentication)

  def create
    position = (Deal.minimum(:position) || 0) - 1

    @deal = Deal.new(deal_params.merge(position: position))

    if @deal.save
      redirect_to root_path, notice: "Deal added."
    else
      reload_home_with_errors
    end
  end

  def update
    @deal = Deal.find(params[:id])

    if @deal.update(deal_params)
      redirect_to root_path, notice: "Deal updated."
    else
      reload_home_with_errors
    end
  end

  def destroy
    @deal = Deal.find(params[:id])
    @deal.destroy
    redirect_to root_path, notice: "Deal removed."
  end

  # PATCH /deals/reorder  (we’ll hook JS to this later if you want drag & drop)
  def reorder
    ids = Array(params[:order])

    ActiveRecord::Base.transaction do
      ids.each_with_index do |id, index|
        Deal.where(id: id).update_all(position: index)
      end
    end

    head :no_content
  end

  private

  def deal_params
    params.require(:deal).permit(:url, :description, :note)
  end

  def reload_home_with_errors
    @site_status = SiteStatus.first_or_create!(body: "")
    @deals = Deal.order(position: :asc, created_at: :desc)
    @deals_last_updated_at = Deal.maximum(:updated_at)
    render "home/index", status: :unprocessable_entity
  end
end
