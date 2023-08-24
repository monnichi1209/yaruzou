class ApplicationController < ActionController::Base
  protected

  def after_sign_in_path_for(resource)
    role_selection_path
  end

  # アクセス制限のためのメソッド
  private

  def ensure_child_belongs_to_current_user
  unless params[:child_id]
  redirect_to root_path, alert: "child_idが提供されていません。"
  return
  end
  
  @child = User.find(params[:child_id])
  unless current_user.children.include?(@child)
  redirect_to root_path, alert: "アクセス権限がありません。"
  end
  end
  end
