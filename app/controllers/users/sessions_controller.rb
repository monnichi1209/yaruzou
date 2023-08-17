class Users::SessionsController < Devise::SessionsController

  def guest_sign_in
    user = User.find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
    end
    sign_in user
    redirect_to tasks_path, notice: 'ゲストユーザーとしてログインしました。'
  end

  def admin_guest_sign_in
    admin = User.find_or_create_by!(email: 'admin_guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.admin = true
    end
    sign_in admin
    redirect_to rails_admin.dashboard_path, notice: '管理者ゲストユーザーとしてログインしました。'
  end
end
