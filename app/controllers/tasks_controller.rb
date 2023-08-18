class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user! 

  def index
    if params[:child_id]
      @tasks = Task.where(user_id: params[:child_id], status: "着手中")
      Rails.logger.debug("Tasks for child_id #{params[:child_id]}: #{@tasks.inspect}")
    else
      @tasks = Task.all
    end
  end
  
  def choose
    task = Task.find(params[:id])
    if task.update(user_id: params[:child_id], status: "着手中")
        redirect_to tasks_path(child_id: params[:child_id]), notice: "お手伝いを選びました！"
    else
        puts task.errors.full_messages # ここでエラーメッセージをログに出力
        redirect_to tasks_path(child_id: params[:child_id]), alert: "何らかのエラーが発生しました。"
    end
  end

  def mark_complete
    task = Task.find(params[:id])
    if task.update(status: "完了")
        redirect_to tasks_path(child_id: task.user_id), notice: "お手伝いが完了しました！"
    else
        redirect_to tasks_path(child_id: task.user_id), alert: "何らかのエラーが発生しました。"
    end
  end

  # tasks_controller.rb
def tasks_for_kids
  @tasks = Task.where.not(status: "着手中")
end


  def rewards
    child_id = params[:child_id]
    @completed_tasks = Task.where(user_id: child_id, status: "完了")
  end  
  
  def under_construction
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
params.require(:task).permit(:name, :description, :status, :due_on, :reward)
end

def set_task
@task = Task.find(params[:id])
end
end

