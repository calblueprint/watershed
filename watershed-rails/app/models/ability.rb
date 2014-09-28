class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.is_manager?
      can :manage, :all
    elsif user.is_employee?
      can :read, :all
    else
      # Community Member
    end
  end

end
