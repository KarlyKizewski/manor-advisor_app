class CleansController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
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

  private

  def clean_params
    params.require(:clean).permit(:message)
  end
end
