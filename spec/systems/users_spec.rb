require 'rails_helper'

RSpec.describe 'ユーザー管理機能', type: :system do
  before(:each) do
    Capybara.reset_sessions!
  end

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
        fill_in '名前', with: 'testuser'
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
        fill_in 'user[email]', with: 'unique_update@example.com'
        fill_in 'user[password]', with: 'newpassword'
        fill_in 'user[password_confirmation]', with: 'newpassword'
        click_on '保存'
        expect(page).to have_content 'ユーザーの 更新しました に成功しました'
      end

      it '管理ユーザはユーザを削除できること' do
        other_user = FactoryBot.create(:user)
        visit "/admin/user/#{other_user.id}/delete"
        click_on 'はい。間違いありません！'
        expect(page).to have_content 'ユーザーの 削除しました に成功しました'
        expect(current_path).to eq '/admin/user'
        expect(page).not_to have_content other_user.name
      end
    end
  end

  describe 'アクセス制限のテスト' do
    let(:user1) { FactoryBot.create(:user) }
    let(:user2) { FactoryBot.create(:user) }
    let!(:task) { FactoryBot.create(:task, user_id: user1.id) }

    context '他のユーザーのタスク編集ページにアクセスしようとした場合' do
      it 'アクセス制限がかかり、編集ページにアクセスできない' do
        # user1でログインしてタスクを作成
        visit new_user_session_path
        fill_in 'Eメール', with: user1.email
        fill_in 'パスワード', with: user1.password
        click_button 'ログイン'
        visit new_task_path
        fill_in 'task[name]', with: 'User1 Task'
        fill_in 'task[description]', with: 'User1 Task Description'
        click_button '登録'
        click_link 'ログアウト'

        # user2でログイン
        visit new_user_session_path
        fill_in 'Eメール', with: user2.email
        fill_in 'パスワード', with: user2.password
        click_button 'ログイン'

        # user1が作成したタスクの編集ページにアクセスしようとする
        visit edit_task_path(task)
        expect(current_path).not_to eq edit_task_path(task)
        expect(page).to have_content 'アクセス権限がありません'
      end
    end
  end

  describe 'セッション機能のテスト' do
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
        expect(current_path).to eq root_path
      end

      it 'ユーザは自身のアカウントを削除できること' do
        visit edit_user_registration_path
        page.accept_alert '本当によろしいですか？' do
          click_on 'アカウント削除'
        end
        expect(page).to have_content 'アカウントを削除しました。またのご利用をお待ちしております。'
        expect(current_path).to eq root_path
      end
    end
  end
end
