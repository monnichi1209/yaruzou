class PagesController < ApplicationController
  
  def home
    @is_home_page = true
    @hide_sidebar = true # これを追加

    if user_signed_in? && current_user.admin?
      sign_out current_user
      redirect_to root_path, notice: '管理者としてのログインを終了しました。'
    end
  end
end
