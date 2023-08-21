class Task < ApplicationRecord
  validates :status, inclusion: { in: ['未着手', '着手中', '完了', '交換ずみ'], message: "%{value} は有効な状態ではありません" }

  after_initialize :set_default_status

  private

  def set_default_status
    self.status ||= '未着手'
  end

end
