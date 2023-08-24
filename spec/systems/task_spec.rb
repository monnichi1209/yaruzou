require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  describe '新規作成機能' do
    before do
      user = FactoryBot.create(:user)
      visit login_path
      fill_in 'email', with: user.email
      fill_in 'password', with: user.password
      click_button 'Submit'
    end
    
    context 'タスクを新規作成した場合' do
      it '作成したタスクが表示される' do
        visit new_task_path
        fill_in 'task[name]', with: 'New Task'
        fill_in 'task[description]', with: 'New Task Content'
        fill_in 'task[expired_at]', with: DateTime.now
        select '未着手', from: 'task[status]' 
        select '高', from: 'task[priority]' 
        find('.actions input[type="submit"]').click

        expect(current_path).to eq task_path(Task.last)
        expect(page).to have_content 'New Task'
        expect(page).to have_content 'New Task Content'
        expect(page).to have_content '未着手' 
        expect(page).to have_content '高'
      end
    end
  end
  
  describe '一覧表示機能' do
    let(:user) { FactoryBot.create(:user) }
    let!(:task1) { FactoryBot.create(:task, name: 'task1', created_at: Time.now - 1.day, user: user, priority: '低') }
    let!(:task2) { FactoryBot.create(:task, name: 'task2', created_at: Time.now, user: user, priority: '高') }

    before do
      visit login_path
      fill_in 'email', with: user.email
      fill_in 'password', with: user.password
      click_button 'Submit'
    end

    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が表示される' do
      visit tasks_path
      expect(page).to have_content 'task1'
      end
    end

    context '優先順位でソートするというリンクを押した場合' do
      it '優先順位の高い順に並び替えられたタスク一覧が表示される' do
        task1 = FactoryBot.create(:task, name: 'task1', priority: '低')
        task2 = FactoryBot.create(:task, name: 'task2', priority: '高')
    
        visit tasks_path(sort_priority: "true")
        tasks = all('tbody tr') 
    
        expect(tasks[0]).to have_content 'task2'
        expect(tasks[1]).to have_content 'task1'
      end
    end

    context '終了期限でソートするというリンクを押した場合' do
      it '終了期限の降順に並び替えられたタスク一覧が表示される' do
        task1 = FactoryBot.create(:task, name: 'task1', expired_at: DateTime.now + 1.day)
        task2 = FactoryBot.create(:task, name: 'task2', expired_at: DateTime.now + 2.days)
    
        visit tasks_path(sort_expired: "true")
        tasks = all('tbody tr') 
    
        expect(tasks[0]).to have_content 'task2'
        expect(tasks[1]).to have_content 'task1'
      end
    end
  end  
  
  describe '詳細表示機能' do
    let(:user) { FactoryBot.create(:user) }
    let!(:task) { FactoryBot.create(:task, name: 'Task Title', description: 'Task Content', created_at: Time.now - 1.day, user: user) }
    before do

      visit login_path
      fill_in 'email', with: user.email
      fill_in 'password', with: user.password
      click_button 'Submit'
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
    let!(:task1) { FactoryBot.create(:task, name: 'task1', created_at: Time.now - 1.day, user: user, status: '未着手') }
    let!(:task2) { FactoryBot.create(:task, name: 'task2', created_at: Time.now, user: user, status: '完了') }

    before do
      visit login_path
      fill_in 'email', with: user.email
      fill_in 'password', with: user.password
      click_button 'Submit'
    end

    context 'タイトルで検索した場合' do
      it '検索したタイトルを含むタスクが表示される' do
        task1 = FactoryBot.create(:task, name: 'task1', status: '未着手')
        task2 = FactoryBot.create(:task, name: 'task2', status: '完了')
        visit tasks_path
        fill_in 'name', with: 'task1'
        click_on 'task_search'
        expect(page).to have_content 'task1'
      end
    end
  
    context 'ステータスで検索した場合' do
      it '選択したステータスに該当するタスクが表示される' do
        visit tasks_path
        select '完了', from: 'status'
        click_on 'task_search'
        expect(page).to have_content '完了'
      end
    end
  
    context 'タイトルとステータスの両方で検索した場合' do
      it '検索したタイトルと選択したステータスに該当するタスクが表示される' do
        visit tasks_path
        fill_in 'name', with: 'task1'
        select '未着手', from: 'status'
        click_on 'task_search'
        expect(page).to have_content '未着手'
      end
    end
  end
end