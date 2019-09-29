class CleansController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit]
  def index
    @cleans = Clean.all
  end

  def new
    @clean = Clean.new
  end

  def create
    @clean = current_user.cleans.create(clean_params)
    if @clean.valid?
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @clean = Clean.find_by_id(params[:id])
    return render_not_found if @clean.blank?
  end

  def edit
    @clean = Clean.find_by_id(params[:id])
    return render_not_found if @clean.blank?
    return render_not_found(:forbidden) if @clean.user != current_user
  end

  private

  def clean_params
    params.require(:clean).permit(:message)
  end

  def render_not_found(status=:not_found)
    render plain: "#{status.to_s.titleize}", status: status
  end

end
