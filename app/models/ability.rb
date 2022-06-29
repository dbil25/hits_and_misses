# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the user here. For example:
    #
    #   return unless user.present?
    #   can :read, :all
    #   return unless user.admin?
    #   can :manage, :all
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, published: true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md


    # must be logged in
    return unless user.present?

    # actions outside tenancy
    can :create, Team
    can :manage, User, itself: user
    can :request_invite, Team

    # inside tenancy
    return if Apartment::Tenant.current == "public"

    # from now on check on member
    team = Team.find_by(tenant_name: Apartment::Tenant.current)
    member = Member.find_by(user: user, team: team)
    return unless member.present?
    return if member.status == "pending"

    can :read, Team, itself: team

    if member.has_role?(:admin)
      can [:update, :destroy], Team, itself: team
      can [:manage, :start], Meeting
      can [:accept_membership, :destroy], Member, team: team
    end
  end
end
