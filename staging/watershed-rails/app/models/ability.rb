class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # Our gracious PL says it's the client's responsiblity to hide things from the user
    can :manage, :all

    if user.manager?
      can :manage, :all
    elsif user.employee?
      can :read, :all
    else
      # Community Member
    end
  end

end
