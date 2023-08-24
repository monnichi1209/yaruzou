require 'rails_helper'
RSpec.describe 'ユーザー管理機能', type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:admin_user) { FactoryBot.create(:admin_user) }
  let(:other_user) { FactoryBot.create(:user) }

  describe 'ユーザー登録のテスト' do
    context 'ユーザーの新規登録ができる場合' do
      it '新規登録が完了されたメッセージが表示される' do
        visit new_user_path
        fill_in 'user[email]', with: 'test@example.com'
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
        click_on 'Create User'
        expect(current_path).to eq tasks_path
        expect(page).to have_content 'Successfully signed up!'
      end
    end
  end

  describe '管理画面のテスト' do
    before do
      visit login_path
      fill_in 'email', with: admin_user.email
      fill_in 'password', with: admin_user.password
      click_button 'Submit'
    end
    
    context '管理ユーザがログインした場合' do
      it 'ユーザの新規登録ができること' do
        visit new_admin_user_path
        fill_in 'user[email]', with: 'newuser@example.com'
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
        click_on 'Create User'
        expect(page).to have_content 'User was successfully created.'
      end
    
      it '管理ユーザはユーザの詳細画面にアクセスできること' do
        other_user = FactoryBot.create(:user)
        visit user_path(other_user)
        expect(current_path).to eq user_path(other_user)
      end
    
      it '管理ユーザはユーザの編集画面からユーザを編集できること' do
        other_user = FactoryBot.create(:user)
        visit edit_admin_user_path(other_user)
        fill_in 'user[email]', with: 'update@example.com'
        click_on 'Update User'
        expect(page).to have_content 'User was successfully updated.'
      end

      it '管理ユーザはユーザの削除をできること' do
        other_user = FactoryBot.create(:user)
        visit admin_users_path
        click_link 'Destroy', href: admin_user_path(other_user)
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content 'User was successfully destroyed.'
      end
      
      it '管理画面にアクセスできること' do
        visit admin_users_path
        expect(current_path).to eq admin_users_path
      end
    end

    context '一般ユーザがログインした場合' do
      before do
        user = FactoryBot.create(:user)
        visit login_path
        fill_in 'email', with: user.email
        fill_in 'password', with: user.password
        click_button 'Submit'
      end
    

      it '管理画面にアクセスできないこと' do
        visit admin_users_path
        expect(current_path).not_to eq admin_users_path
      end
    end
  end


  describe 'セッション機能のテスト' do
    let(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:user) }

    before do
      visit login_path
      fill_in 'email', with: user.email
      fill_in 'password', with: user.password
      click_button 'Submit'
    end

    context 'ユーザがログイン画面からログインした場合' do
      it 'ログインに成功する' do
        expect(current_path).to eq tasks_path
      end

      it '自分の詳細画面(マイページ)に飛べること' do
        visit user_path(user)
        expect(current_path).to eq user_path(user)
      end
    end

    context '一般ユーザが他人の詳細画面に飛ぶと' do
      it 'タスク一覧画面に遷移する' do
        visit user_path(other_user)
        expect(current_path).to eq tasks_path
      end
    end

    context 'ログインしている場合' do
      it 'ログアウトができること' do
        click_link 'Logout'
        expect(page).to have_content 'Logged out'
      end
    end
  end
end