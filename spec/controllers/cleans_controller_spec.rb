require 'rails_helper'

RSpec.describe CleansController, type: :controller do
  describe "cleans#index action" do
    it "should successfully show the page" do
      expect(response).to have_http_status(:success)
    end
  end


end
