class CleansController < ApplicationController
  before_action :authenticate_user!, only: [:new]
  def index
    @cleans = Clean.all
  end

  def new
    @clean = Clean.new
  end
end
