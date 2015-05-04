class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # Our gracious PL says it's the client's responsiblity to hide things from the user
    # can :manage, :all
    can :manage, FieldReport
    can :read, MiniSite
    can :read, Task
    can :read, Site

    can :manage, User, id: user.id

    if user.manager?
      can :manage, :all
    end
  end

end
