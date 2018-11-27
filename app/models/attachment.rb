class Attachment < ApplicationRecord
  validates :file, presence: true

  belongs_to :attachable, polymorphic: true, optional: true, required: true

  mount_uploader :file, FileUploader
end
