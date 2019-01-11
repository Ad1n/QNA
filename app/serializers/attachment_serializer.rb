class AttachmentSerializer < BaseSerializer
  attribute :file do
    object.file.url
  end
end