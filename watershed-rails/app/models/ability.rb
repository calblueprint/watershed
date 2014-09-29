class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.manager?
      can :manage, :all
    elsif user.employee?
      can :read, :all
    else
      # Community Member
    end
  end

end
