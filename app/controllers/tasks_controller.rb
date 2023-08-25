class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user! 
  before_action :ensure_child_belongs_to_current_user, only: [:rewards]

  def index
    if params[:child_id]
      @tasks = Task.where(user_id: params[:child_id], status: "着手中").page(params[:page]).per(5)
    else
      @tasks = Task.page(params[:page]).per(5)
    end
  end
  

  def choose
    task = Task.find(params[:id])
    if task.update(user_id: params[:child_id], status: "着手中")
        redirect_to tasks_path(child_id: params[:child_id]), notice: "おてつだいがんばってね！"
    else
        puts task.errors.full_messages # ここでエラーメッセージをログに出力
        redirect_to tasks_path(child_id: params[:child_id]), alert: "何らかのエラーが発生しました。"
    end
  end

  def mark_complete
    @task = Task.find(params[:id])
    @task.update(status: "完了")
    
    child = User.find(@task.user_id) # タスクのユーザー（子供）を取得
    child.points ||= 0
    reward_points = @task.reward || 0
    child.points += reward_points # 子供のポイントを加算
    
    if child.save(validate: false)
        Rails.logger.debug("Child's points updated successfully to: #{child.points}")
    else
        Rails.logger.error("Error updating child's points: #{child.errors.full_messages.join(', ')}")
    end
  
    redirect_to tasks_path(child_id: child.id), notice: 'おてつだいありがとう！！'
end

  def tasks_for_kids
    # 現在ログインしているユーザー（親）が作成したタスクのみを取得
    @tasks = Task.where(user_id: current_user.id).where.not(status: "着手中")
  end
  
  def rewards
    # child_id が提供されている場合はそれを使用し、提供されていない場合はデフォルトの子供を設定
    child_id = params[:child_id] || current_user.children.first&.id
  
    # デフォルトの子供も存在しない場合はエラーメッセージを表示
    unless child_id
      redirect_to root_path, alert: "関連する子供が存在しません。"
      return
    end
  
    @completed_tasks = Task.where(user_id: child_id, status: "完了")
    @total_reward = @completed_tasks.sum(:reward)
    @exchanged_items = Task.where(user_id: child_id, status: "交換済み")
  end

  def show
    @task = Task.find(params[:id])
    @hide_sidebar = true
  end

  def new
    @task = Task.new
    @hide_sidebar = true
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id # ここで親のIDを設定
    if @task.save
      redirect_to dashboard_parents_path, notice: 'お手伝いが正常に作成されました'
    else
      render :new
    end
  end
  
  def cancel_task
    @task = Task.find(params[:id])
    @task.update(status: "未着手", user_id: current_user.id)
    redirect_back(fallback_location: tasks_path, notice: 'おてつだいをやめました。')
  end
  
  def edit
    @task = Task.find(params[:id])
    @hide_sidebar = true
  
    # 現在ログインしているユーザーがタスクの作成者でない場合
    unless @task.user_id == current_user.id
      redirect_to tasks_path, alert: 'アクセス権限がありません'
      return
    end
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to @task, notice: 'お手伝いが正常に更新されました'
    else
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to dashboard_parents_path, notice: 'おてつだいが正常に削除されました'
  end
  

  def exchange_reward
    item = params[:item]
    required_points = params[:points].to_i
    child = User.find(params[:child_id]) # 子供のユーザー情報を取得
    child_points = child.points || 0

    if child_points >= required_points
      new_points = child_points - required_points
      
      # update_columnsを使用してバリデーションをスキップしpointsだけを更新
      child.update_columns(points: new_points)
      
      # 新しいタスクを "交換済み" ステータスで作成
      Task.create(name: item, status: "交換済み", user_id: child.id, description: "#{item}とこうかんしました。")
    
      redirect_to rewards_tasks_path(child_id: child.id), notice: "#{item}をこうかんしました！"
    else
      redirect_to rewards_tasks_path(child_id: child.id), alert: "ポイントがたりません。"
    end
end

  
private

def task_params
params.require(:task).permit(:name, :description, :status, :due_on, :reward)
end

def set_task
@task = Task.find(params[:id])
end

end

