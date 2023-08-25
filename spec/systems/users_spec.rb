require 'rails_helper'
RSpec.describe 'ユーザー管理機能', type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:admin_user) { FactoryBot.create(:admin_user) }
  let(:other_user) { FactoryBot.create(:user) }

  describe 'ユーザー登録のテスト' do
    context 'ユーザーの新規登録ができる場合' do
      it '新規登録が完了されたメッセージが表示される' do
        visit new_user_registration_path

        fill_in 'ユーザー名', with: 'testuser'
        fill_in 'Eメール', with: 'test@example.com'
        fill_in 'Eメール（確認用）', with: 'test@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード（確認用）', with: 'password'
        click_on 'アカウント登録'
        expect(current_path).to eq role_selection_path
        expect(page).to have_content 'アカウント登録が完了しました。'
      end
    end
  end

  describe '管理画面のテスト' do
    before do
      visit new_user_session_path 
      fill_in 'Eメール', with: admin_user.email
      fill_in 'パスワード', with: admin_user.password
      click_button 'ログイン'
    end
    
    context '管理ユーザがログインした場合' do
      it 'ユーザの新規登録ができること' do
        visit '/admin/user/new'
        fill_in 'Name', with: 'testuser'
        fill_in 'Eメール', with: 'test@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード（確認用）', with: 'password'
        click_on '保存'
        expect(page).to have_content 'ユーザーの 作成しました に成功しました'
      end
    
      it '管理ユーザはユーザの詳細画面にアクセスできること' do
        other_user = FactoryBot.create(:user)
        visit "/admin/user/#{other_user.id}"
        expect(current_path).to eq "/admin/user/#{other_user.id}"

      end
    
      it '管理ユーザはユーザの編集画面からユーザを編集できること' do
        other_user = FactoryBot.create(:user)
        visit "/admin/user/#{other_user.id}/edit"
        fill_in 'user[email]', with: 'unique_update@example.com' # ユニークなEメールアドレスに変更
        fill_in 'user[password]', with: 'newpassword' # パスワードも入力
        fill_in 'user[password_confirmation]', with: 'newpassword' # 確認用パスワードも入力
        click_on '保存'
        expect(page).to have_content 'ユーザーの 更新しました に成功しました' # 期待するメッセージを成功に関するものに変更
      end
    end
  end

describe 'セッション機能のテスト' do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }

  before do
    visit new_user_session_path
    fill_in 'Eメール', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログイン'
  end

  context 'ユーザがログイン画面からログインした場合' do
    it 'ログインに成功する' do
      expect(current_path).to eq role_selection_path
      expect(page).to have_content 'ログインしました。'
    end
  end

  context 'ログインしている場合' do
    it 'ログアウトができること' do
      click_link 'ログアウト'
      expect(page).to have_content 'ログアウトしました。'
      expect(current_path).to eq root_path # 期待値をルートパスに変更
    end
  end
end
end