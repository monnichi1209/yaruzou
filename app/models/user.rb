class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable

  validates :email, confirmation: true
  validates :name, presence: true
  validates :email, :password, presence: true, unless: -> { role == 'kid' }

  enum role: { kid: 0, guardian: 1 }

  # このユーザーが親として持つ関連 (子供たち)
  has_many :child_links, class_name: 'FamilyLink', foreign_key: :parent_id
  has_many :children, through: :child_links, source: :child

  # このユーザーが子供として持つ関連 (親たち)
  has_many :parent_links, class_name: 'FamilyLink', foreign_key: :child_id
  has_many :parents, through: :parent_links, source: :parent

  before_create :set_default_role

  private

  def set_default_role
    self.role ||= 'guardian'
  end
end
