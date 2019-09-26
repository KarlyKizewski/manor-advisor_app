require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  describe "tasks#index action" do
    it "should successfully show the page" do 
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "tasks#new action" do
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

  describe "tasks#create action" do
    it "should require users to be logged in" do
      post :create, params: { task: { message: "Home" } }
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully create a new task in the database" do
      user = FactoryBot.create(:user)
      sign_in user

      post :create, params: { task: { message: 'Get home together!' } }
      expect(response).to redirect_to root_path

      task = Task.last
      expect(task.message).to eq("Get home together!")
      expect(task.user).to eq(user)
    end

    it "should properly deal with validation errors" do
      user = FactoryBot.create(:user)
      sign_in user

      task_count = Task.count
      post :create, params: { task: { message: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(task_count).to eq Task.count
    end
  end
end
