require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  describe '新規作成機能' do
    before do
      user = FactoryBot.create(:user)
      visit new_user_session_path
      fill_in 'Eメール', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'
    end
    
    context 'タスクを新規作成した場合' do
      it '作成したタスクが表示される' do
        visit new_task_path
        fill_in 'task[name]', with: 'New Task'
        fill_in 'task[description]', with: 'New Task Content'
        select '今日', from: 'task[due_on]'
        find('.actions input[type="submit"]').click

        expect(current_path).to eq dashboard_parents_path
        expect(page).to have_content 'New Task'
        expect(page).to have_content 'New Task Content'
      end
    end
  end
  
  describe '一覧表示機能' do
    let(:user) { FactoryBot.create(:user) }
    let!(:task1) { FactoryBot.create(:task, name: 'task1', description: 'Some description', user_id: user.id) }
    let!(:task2) { FactoryBot.create(:task, name: 'task1', description: 'Some description', user_id: user.id) }

    before do
      visit new_user_session_path
      fill_in 'Eメール', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'
    end

    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が表示される' do
      visit tasks_path
      expect(page).to have_content 'task1'
      end
    end
  end  
  
  describe '詳細表示機能' do
    let(:user) { FactoryBot.create(:user) }
    let!(:task) { FactoryBot.create(:task, name: 'Task Title', description: 'Task Content', created_at: Time.now - 1.day, user_id: user.id) }
    before do

      visit new_user_session_path
      fill_in 'Eメール', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'
    end

    context '任意のタスク詳細画面に遷移した場合' do
      it '該当タスクの内容が表示される' do
        visit task_path(task)
        expect(page).to have_content 'Task Title'
        expect(page).to have_content 'Task Content'
      end
    end
  end

  describe '検索機能' do
    let(:user) { FactoryBot.create(:user) }
    let!(:task1) { FactoryBot.create(:task, name: 'task1', created_at: Time.now - 1.day, user_id: user.id, status: '未着手') }
    let!(:task2) { FactoryBot.create(:task, name: 'task2', created_at: Time.now, user_id: user.id, status: '完了') }

    before do
      visit new_user_session_path
      fill_in 'Eメール', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'
    end

    context 'タイトルで検索した場合' do
      it '検索したタイトルを含むタスクが表示される' do
        task1 = FactoryBot.create(:task, name: 'task1', user_id: user.id)
        task2 = FactoryBot.create(:task, name: 'task2', user_id: user.id)
        visit dashboard_parents_path
        fill_in 'お手伝い名', with: 'task1'
        click_on 'フィルタリング&ソート'
        expect(page).to have_content 'task1'
      end
    end
  
    context 'ステータスで検索した場合' do
      it '選択したステータスに該当するタスクが表示される' do
        visit dashboard_parents_path
        select '未着手', from: 'status_filter'
        click_on 'フィルタリング&ソート'
        expect(page).to have_content '未着手'
      end
    end
  
    context 'タイトルとステータスの両方で検索した場合' do
      it '検索したタイトルと選択したステータスに該当するタスクが表示される' do
        visit dashboard_parents_path
        fill_in 'お手伝い名', with: 'task1'
        select '未着手', from: 'status_filter'
        click_on 'フィルタリング&ソート'
        expect(page).to have_content '未着手'
      end
    end
  end
end