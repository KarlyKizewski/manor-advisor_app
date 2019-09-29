require 'rails_helper'

RSpec.describe CleansController, type: :controller do
  describe "cleans#index action" do
    it "should successfully show the page" do
      expect(response).to have_http_status(:success)
    end
  end

  describe "cleans#new action" do
    it "should require users to be logged in" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the new form" do
      user = FactoryBot.create(:user)
      sign_in user
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "cleans#create action" do
    it "should require users to be logged in" do
      post :create, params: { clean: { message: "Home" } }
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully create a new task in the database" do
      user = FactoryBot.create(:user)
      sign_in user
      post :create, params: { clean: { message: "Get home clean!" } }
      expect(response).to redirect_to root_path
      clean = Clean.last
      expect(clean.message).to eq("Get home clean!")
      expect(clean.user).to eq(user)
    end

    it "should properly deal with validation errors" do
      user = FactoryBot.create(:user)
      sign_in user 
      clean_count = Clean.count 
      post :create, params: { clean: { message: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(clean_count).to eq Clean.count 
    end
  end

  describe "cleans#show action" do
    it "should successfully show the page if the clean is found" do
      clean = FactoryBot.create(:clean)
      get :show, params: { id: clean.id }
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error if the clean is not found" do
      get :show, params: { id: 'NADA' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "cleans#edit action" do
    it "shouldn't let a user who did not create the clean edit the clean" do
      clean = FactoryBot.create(:clean)
      user = FactoryBot.create(:user)
      sign_in user
      get :edit, params: { id: clean.id }
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unauthenticated users edit a clean" do
      clean = FactoryBot.create(:clean)
      get :edit, params: { id: clean.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the edit form if the clean is found" do
      clean = FactoryBot.create(:clean)
      get :edit, params: { id: clean.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "should return a 404 error message if the clean is not found" do
      user = FactoryBot.create(:user)
      sign_in user
      get :edit, params: { id: 'OOPS' }
      expect(response).to have_http_status(:not_found)
    end
  end
end
