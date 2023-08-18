class ParentsController < ApplicationController
  before_action :set_guardian_flag

  def new_child
    @child = User.new
  end

  def create_child
    @child = User.new(child_params)
    @child.role = "kid"

    @child.email = SecureRandom.uuid + "@example.com"
    @child.password = SecureRandom.hex(8)

    if @child.save
      FamilyLink.create(parent: current_user, child: @child)
      redirect_to dashboard_parents_path, notice: "子どもを追加しました"
    else
      render :new_child
    end
  end

  def dashboard
    @children = current_user.children
    @tasks = Task.where(user_id: @children)
  end

  private

  def child_params
  params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def set_guardian_flag
  @is_guardian_page = true
  end
  end
