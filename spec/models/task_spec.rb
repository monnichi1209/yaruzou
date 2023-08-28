require 'rails_helper'

RSpec.describe Task, type: :model do
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

    context 'タスクのステータスが許可されていない値の場合' do
      it 'バリデーションに引っかかる' do
        task = Task.new(name: 'タイトル', description: '詳細', status: '無効なステータス')
        expect(task).not_to be_valid
      end
    end

    context 'タスクのタイトルと詳細に内容が記載されている場合' do
      it 'バリデーションが通る' do
        task = Task.new(name: 'タイトル', description: '詳細', status: '未着手')
        expect(task).to be_valid
      end
    end
  end
end
