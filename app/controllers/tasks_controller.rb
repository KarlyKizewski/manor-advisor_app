class TasksController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def new
    @task = Task.new
  end


  def index
  end

  def show
    @task = Task.find_by_id(params[:id])
    return render_not_found if @task.blank?
  end

  def create
    @task = current_user.tasks.create(task_params)
    if @task.valid?
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @task = Task.find_by_id(params[:id])
    return render_not_found if @task.blank?
    return render_not_found(:forbidden) if @task.user != current_user
  end

  def update
    @task = Task.find_by_id(params[:id])
    return render_not_found if @task.blank?
    return render_not_found(:forbidden) if @task.user != current_user
    @task.update_attributes(task_params)
    if @task.valid?
     redirect_to root_path
    else
      return render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task = Task.find_by_id(params[:id])
    return render_not_found if @task.blank?
    return render_not_found(:forbidden) if @task.user != current_user
    @task.destroy
    redirect_to root_path
  end  

  private

  def task_params
    params.require(:task).permit(:message)
  end

  def render_not_found(status=:not_found)
    render plain: "#{status.to_s.titleize}", status: status
  end
end
