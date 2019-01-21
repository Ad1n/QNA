class SubscribesController < ApplicationController

  before_action :set_subscribable, only: %i[create destroy]
  before_action :set_subscribe, only: %i[destroy]

  authorize_resource

  def create
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

  def destroy
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
    @subscribable = find_subscribable
  end

  def find_subscribable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        @subscribable = $1.classify.constantize.find(value)
        return @subscribable
      end
    end
    nil
  end

  def comments_params
    params.require(:subscribe)
  end
end
