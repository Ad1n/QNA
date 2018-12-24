class AttachmentsController < ApplicationController

  before_action :set_attachment, only: %i[destroy]

  authorize_resource

  def destroy
    @attachment.destroy
  end

  private

  def set_attachment
    @attachment = Attachment.find(params[:id])
  end
end
