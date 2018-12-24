class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], user: @user
    can :destroy, [Question, Answer], user: @user
    can :choose_best, Answer do |answer|
      answer.question.user == @user
    end

    can :vote, [Question, Answer] do |object|
      object.user != @user && object.can_vote?(@user, "vote")
    end

    can :unvote, [Question, Answer] do |object|
      object.user != @user && object.can_vote?(@user, "unvote")
    end

    can :destroy, Attachment do |attachment|
      attachment.attachable.user == @user
    end

  end
end
