class PagesController < ApplicationController
  def home
    if user_signed_in? && current_user.admin?
      sign_out current_user
      redirect_to root_path, notice: '管理者としてのログインを終了しました。'
    end
  end
end
