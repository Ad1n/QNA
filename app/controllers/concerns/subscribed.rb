module Subscribed
  extend ActiveSupport::Concern

  included do
    before_action :set_subscribable, only: %i[subscribe unsubscribe]
    before_action :set_subscribe, only: %i[unsubscribe]
  end

  def subscribe
    if @subscribable.subscribe_by(current_user).empty?
      @subscribe = @subscribable.subscribes.new(user: current_user)
      respond_to do |format|
        if @subscribe.save
          format.json { render json: { subscribe: @subscribe } }
        else
          format.json { render json: @subscribe.errors.full_messages, status: :unprocessable_entity}
        end
      end
    end
  end

  def unsubscribe
    if @subscribable.subscribe_by(current_user).any?
      respond_to do |format|
        if @subscribe.destroy
          format.json { render json: { message: "Successfully destroyed!", subscribe: @subscribe } }
        else
          format.json { render json: @subscribe.errors.full_messages, status: :unprocessable_entity}
        end
      end
    end
  end

  private

  def set_subscribe
    @subscribe = @subscribable.subscribe_by(current_user).first
  end

  def set_subscribable
    @subscribable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end
end
