class ParentsController < ApplicationController
  before_action :set_guardian_flag

  def new_child
    @child = User.new
  end

  def create_child
    @child = User.new(child_params)
    @child.role = 'kid'
    @child.email = SecureRandom.uuid + '@example.com'
    @child.password = SecureRandom.hex(8)
    if @child.save
      FamilyLink.create(parent: current_user, child: @child)
      redirect_to dashboard_parents_path, notice: '子どもを追加しました'
    else
      flash.now[:alert] = '名前を入力して下さい。'
      render :new_child
    end
  end

  def destroy_child
    child = User.find(params[:id])
    child.destroy
    redirect_to dashboard_parents_path, notice: "#{child.name} を削除しました"
  end

  def dashboard
    @children = current_user.children

    # 1. パラメータからフィルタリングやソートの値を取得
    name_filter = params[:name_filter]
    status_filter = params[:status_filter]
    sort_option = params[:sort]

    # 2. 取得した値に基づいて、@tasks のクエリを修正
    tasks_query = Task.where(user_id: @children + [current_user.id])

    tasks_query = tasks_query.where.not(status: '交換済み')

    # 名前でのフィルタリング
    tasks_query = tasks_query.where('name LIKE ?', "%#{name_filter}%") if name_filter.present?

    # 状態でのフィルタリング
    tasks_query = tasks_query.where(status: status_filter) unless status_filter == '全て' || status_filter.blank?

    # ソート
    case sort_option
    when '期限昇順'
      tasks_query = tasks_query.order(due_on: :asc)
    when '期限降順'
      tasks_query = tasks_query.order(due_on: :desc)
    when '報酬昇順'
      tasks_query = tasks_query.order(reward: :asc)
    when '報酬降順'
      tasks_query = tasks_query.order(reward: :desc)
    end

    @tasks = tasks_query.page(params[:page]).per(5)

    @children_with_tasks = @children.map do |child|
      tasks = Task.where(user_id: child.id, status: %w[着手中 完了])
      completed_tasks = tasks.where(status: '完了')
      total_reward = completed_tasks.sum(:reward)
      {
        child: child,
        tasks: tasks,
        total_reward: total_reward
      }
    end
  end

  private

  def child_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def set_guardian_flag
    @is_guardian_page = true
  end
end
