class TasksController < ApplicationController
  def index
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.create(task_params)
    if @task.valid?
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def task_params
    params.require(:task).permit(:message)
  end
end
