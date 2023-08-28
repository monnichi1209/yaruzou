class Task < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :status, inclusion: { in: %w[未着手 着手中 完了 交換済み], message: '%<value>s は有効な状態ではありません' }

  after_initialize :set_default_status

  private

  def set_default_status
    self.status ||= '未着手'
  end
end
