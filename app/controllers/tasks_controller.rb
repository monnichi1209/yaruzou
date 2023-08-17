class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user! 

  def index
    @tasks = Task.all
  end

  def tasks_for_kids
    @tasks = Task.all 
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to @task, notice: 'タスクが正常に作成されました'
    else
      render :new
    end
  end
  
  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to @task, notice: 'タスクが正常に更新されました'
    else
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to tasks_url, notice: 'タスクが正常に削除されました'
  end
  
  private

def task_params
params.require(:task).permit(:name, :description, :status, :due_on, :user_id, :reward)
end
end

