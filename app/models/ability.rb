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

    can :create, Subscribe do |object|
      object.subscribe_by(@user).empty?
    end

    can :destroy, Subscribe do |object|
      object.subscribable.subscribe_by(@user).any?
    end

    can :index, Question
    can :show, Answer
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], user_id: @user.id
    can :destroy, [Question, Answer], user_id: @user.id
    can :choose_best, Answer do |answer|
      @user.author_of?(answer.question)
    end

    can :vote, [Question, Answer] do |object|
      !@user.author_of?(object) && object.can_vote?(@user, "vote")
    end

    can :unvote, [Question, Answer] do |object|
      !@user.author_of?(object) && object.can_vote?(@user, "unvote")
    end

    can :destroy, Attachment do |attachment|
      @user.author_of?(attachment.attachable)
    end

    can :me, User, user_id: @user.id
    cannot :index, User

  end
end
