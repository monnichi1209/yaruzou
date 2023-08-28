class Users::SessionsController < Devise::SessionsController
  def guest_sign_in
    user = User.find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = 'Guest User'
    end
    sign_in user

    # ゲストユーザーの子供を作成
    child = User.find_or_create_by!(email: SecureRandom.uuid + '@example.com') do |child|
      child.password = SecureRandom.hex(8)
      child.name = 'Guest Child'
      child.role = 'kid' # 必要に応じて子供の役割や他の属性を設定します
    end

    # 作成した子供をゲストユーザーと関連付けるためのFamilyLinkを作成
    FamilyLink.find_or_create_by!(parent: user, child: child)

    redirect_to role_selection_path, notice: 'ゲストユーザーとしてログインしました。'
  end

  def admin_guest_sign_in
    admin = User.find_or_create_by!(email: 'admin_guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.admin = true
      user.name = 'Guest User' # ここで name 属性に値を設定
    end
    sign_in admin
    redirect_to rails_admin.dashboard_path, notice: '管理者ゲストユーザーとしてログインしました。'
  end
end
