require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションのテスト' do
    context 'ユーザーの名前が空の場合' do
      it 'バリデーションに引っかかる' do
        user = User.new(name: '', email: 'test@example.com', password: 'password')
        expect(user).not_to be_valid
      end
    end

    context 'ユーザーのメールアドレスが空の場合' do
      it 'バリデーションに引っかかる' do
        user = User.new(name: 'Test User', email: '', password: 'password')
        expect(user).not_to be_valid
      end
    end

    context 'ユーザーのパスワードが空の場合' do
      it 'バリデーションに引っかかる' do
        user = User.new(name: 'Test User', email: 'test@example.com', password: '')
        expect(user).not_to be_valid
      end
    end

    context 'ユーザーのメールアドレスと確認用メールアドレスが一致しない場合' do
      it 'バリデーションに引っかかる' do
        user = User.new(name: 'Test User', email: 'test@example.com', email_confirmation: 'mismatch@example.com', password: 'password')
        expect(user).not_to be_valid
      end
    end

    context 'ユーザーの名前、メールアドレス、パスワードが適切に設定されている場合' do
      it 'バリデーションが通る' do
        user = User.new(name: 'Test User', email: 'test@example.com', password: 'password')
        expect(user).to be_valid
      end
    end
  end
end
