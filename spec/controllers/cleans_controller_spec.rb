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

  describe "cleans#update action" do
    it "shouldn't let users who didn't create the clean update it" do
      clean = FactoryBot.create(:clean)
      user = FactoryBot.create(:user)
      sign_in user
      patch :update, params: { id: clean.id, task: { message: 'ZUU' } }
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unauthenticated users update a clean" do
      clean = FactoryBot.create(:clean)
      patch :update, params: { id: clean.id, clean: { message: 'Hello' } }
      expect(response).to redirect_to new_user_session_path
    end

    it "should allow users to successfully update cleans" do
      clean = FactoryBot.create(:clean)
      sign_in clean.user
      patch :update, params: { id: clean.id, clean: { message: "Changed" } }
      expect(response).to redirect_to root_path
      clean.reload
      expect(clean.message).to eq "Changed"
    end

    it "should have http 404 error if the clean cannot be found" do
      user = FactoryBot.create(:user)
      sign_in user
      patch :update, params: { id: "Howdy", clean: { message: "Changed" } }
      expect(response).to have_http_status(:not_found)
    end

    it "should render the edit form with an http status of unprocessable_entity" do
      clean = FactoryBot.create(:clean, message: "Initial value")
      sign_in clean.user
      patch :update, params: { id: clean.id, clean: { message: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      clean.reload
      expect(clean.message).to eq "Initial value"
    end
  end

  describe "cleans#destroy action" do
    it "shouldn't allow users who did not create the clean to destroy it" do
      clean = FactoryBot.create(:clean)
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy, params: { id: clean.id }
      expect(response).to have_http_status(:forbidden)
    end

    it "should't let unauthenticated users destroy a clean" do
      clean = FactoryBot.create(:clean)
      delete :destroy, params: { id: clean.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "should allow a user to destroy cleans" do
      clean = FactoryBot.create(:clean)
      sign_in clean.user
      delete :destroy, params: { id: clean.id }
      expect(response).to redirect_to root_path
      clean = Clean.find_by_id(clean.id)
      expect(clean).to eq nil
    end

    it "should return a 404 message if we cannot find a clean with the same id that is specified" do
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy, params: { id: 'SILLY' }
      expect(response).to have_http_status(:not_found)
    end
  end
end
