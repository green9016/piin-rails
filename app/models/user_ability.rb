# frozen_string_literal: true

class UserAbility
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
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
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

    #  TODO - need to add more abilities here as per the roles.
    if user.business?
      business_rules
    elsif user.user?
      user_rules
    else
      default_rules
    end
  end

  private

  def business_rules
    # can :manage, Pin do |pin|
    #   pin.firm.trusties.pluck(:user_id).include?(user.id)
    # end
    can :read, Pin
    can :read, Post
  end

  def user_rules
    can :read, Pin
    can :read, Post
  end

  def default_rules
    can :read, :all
    cannot :manage, 'V1::Admin::Dashboard'
    cannot :manage, User
  end
end
