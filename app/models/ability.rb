class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.try(:admin?)

    can :access, :rails_admin
    can :manage, :all
  end
end
