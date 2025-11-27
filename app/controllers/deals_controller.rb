class DealsController < ApplicationController
  allow_unauthenticated_access only: [:report_broken]
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

  def move_up
    @deal = Deal.find(params[:id])
    above = Deal.where("position < ?", @deal.position).order(position: :desc).first
    swap_positions(@deal, above) if above

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to root_path }
    end
  end

  def move_down
    @deal = Deal.find(params[:id])
    below = Deal.where("position > ?", @deal.position).order(position: :asc).first
    swap_positions(@deal, below) if below

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to root_path }
    end
  end

  def report_broken
    @deal = Deal.find(params[:id])
    @deal.increment!(:broken_reports_count)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to root_path, notice: "Thanks, noted." }
    end
  end

  def reset_broken
    @deal = Deal.find(params[:id])
    @deal.update!(broken_reports_count: 0)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to root_path, notice: "Broken reports reset." }
    end
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

  def swap_positions(a, b)
    a_pos = a.position
    b_pos = b.position
    a.update!(position: b_pos)
    b.update!(position: a_pos)
  end

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
