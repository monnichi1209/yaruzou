require 'rails_helper'

RSpec.describe 'タスクモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    context 'タスクのタイトルが空の場合' do
      it 'バリデーションに引っかかる' do
        task = Task.new(name: '', description: '失敗テスト')
        expect(task).not_to be_valid
      end
    end

    context 'タスクの詳細が空の場合' do
      it 'バリデーションに引っかかる' do
        task = Task.new(name: 'タイトル', description: '')
        expect(task).not_to be_valid
      end
    end

    context 'タスクのタイトルと詳細に内容が記載されている場合' do
      it 'バリデーションが通る' do
        task = Task.new(name: 'タイトル', description: '詳細', status: '未着手', priority: '高')
        expect(task).to be_valid
      end
    end
  end

  describe 'scopeのテスト' do
    let!(:task1) { FactoryBot.create(:task, name: 'task1', status: '未着手') }
    let!(:task2) { FactoryBot.create(:task, name: 'task2', status: '着手中') }
    let!(:task3) { FactoryBot.create(:task, name: 'task3', status: '完了') }

    context 'scopeメソッドでタイトルのあいまい検索ができる' do
      it '検索キーワードを含むタスクが絞り込まれる' do
        expect(Task.search_by_name('task1')).to include(task1)
        expect(Task.search_by_name('task1')).not_to include(task2)
        expect(Task.search_by_name('task1')).not_to include(task3)
      end
    end

    context 'scopeメソッドでステータス検索ができる' do
      it 'ステータスに完全一致するタスクが絞り込まれる' do
        expect(Task.search_by_status('未着手')).to include(task1)
        expect(Task.search_by_status('未着手')).not_to include(task2)
        expect(Task.search_by_status('未着手')).not_to include(task3)
      end
    end

    context 'scopeメソッドでタイトルのあいまい検索、かつステータスの両方が検索できる' do
      it '検索キーワードを含み且つステータスが一致するタスクが絞り込まれる' do
        expect(Task.search_by_name('task1').search_by_status('未着手')).to include(task1)
        expect(Task.search_by_name('task1').search_by_status('未着手')).not_to include(task2)
        expect(Task.search_by_name('task1').search_by_status('未着手')).not_to include(task3)
      end
    end
  end
end
