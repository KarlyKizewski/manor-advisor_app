class CleansController < ApplicationController

  def index
    @cleans = Clean.all
  end
end
