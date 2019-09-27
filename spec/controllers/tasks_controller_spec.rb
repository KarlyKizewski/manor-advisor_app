require 'rails_helper'

RSpec.describe TasksController, type: :controller do

  describe "tasks#destroy action" do
    it "shouldn't allow users who did not create the task to destroy it" do
      task = FactoryBot.create(:task)
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy, params: { id: task.id }
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unauthenticated users destroy a gram" do
      task = FactoryBot.create(:task)
      delete :destroy, params: { id: task.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "should allow a user to destroy tasks" do
      task = FactoryBot.create(:task)
      sign_in task.user
      delete :destroy, params: { id: task.id }
      expect(response).to redirect_to root_path
      task = Task.find_by_id(task.id)
      expect(task).to eq nil
    end

    it "should return a 404 message if we cannot find a task with the id that is specified" do
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy, params: { id: 'SILLY' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "tasks#update" do
    it "shouldn't let users who didn't create the task upate it" do
      task = FactoryBot.create(:task)
      user = FactoryBot.create(:user)
      sign_in user
      patch :update, params: { id: task.id, task: { message: 'Zoinks' } }
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unauthenticated users update a task" do
      task = FactoryBot.create(:task)
      patch :update, params: { id: task.id, task: { message: "Hello" } }
      expect(response).to redirect_to new_user_session_path
    end
      
    it "should allow users to successfully update tasks" do
      task = FactoryBot.create(:task, message: "Initial Value")
      sign_in task.user
      patch :update, params: { id: task.id, task: { message: 'Changed' } }
      expect(response).to redirect_to root_path
      task.reload
      expect(task.message).to eq "Changed"
    end

    it "should have http 404 error if the task cannot be found" do
      user = FactoryBot.create(:user)
      sign_in user
      patch :update, params: { id: "Howdy", task: { message: 'Changed' } }
      expect(response).to have_http_status(:not_found)
    end

    it "should render the edit form with an http status of unprocessable_entity" do
      task = FactoryBot.create(:task, message: "Initial Value")
      sign_in task.user
      patch :update, params: { id: task.id, task: { message: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      task.reload
      expect(task.message).to eq "Initial Value"
    end
  end

  describe "tasks#edit action" do
    it "shouldn't let a user who did not create the task edit the task" do
      task = FactoryBot.create(:task)
      user = FactoryBot.create(:user)
      sign_in user
      get :edit, params: { id: task.id }
      expect(response).to have_http_status(:forbidden)
    end

    it "should't let unauthenticated users edit a task" do
      task = FactoryBot.create(:task)
      get :edit, params: { id: task.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the edit form if the task is found" do
      task = FactoryBot.create(:task)
      sign_in task.user
      get :edit, params: { id: task.id }
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error message if the task is not found" do
      user = FactoryBot.create(:user)
      sign_in user
      get :edit, params: { id: 'OOPS' }
      expect(response).to have_http_status(:not_found)
    end

  end

  describe "tasks#show action" do
    it "should successfully show the page if the task is found" do
      task = FactoryBot.create(:task)
      get :show, params: { id: task.id }
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error if the task is not found" do
      get :show, params: { id: 'NOTHERE' }
      expect(response).to have_http_status(:not_found)
    end
  end

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
