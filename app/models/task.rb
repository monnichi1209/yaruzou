class Task < ApplicationRecord
  validates :status, inclusion: { in: ['未着手', '着手中', '完了'], message: "%{value} は有効な状態ではありません" }

end
