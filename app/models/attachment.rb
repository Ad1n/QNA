class Attachment < ApplicationRecord
  validates :file, presence: true

  belongs_to :attachable, polymorphic: true, inverse_of: :attachment

  mount_uploader :file, FileUploader
end
