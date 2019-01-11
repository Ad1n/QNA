class BaseSerializer < ActiveModel::Serializer
  ActiveModelSerializers.config.adapter = :json

  def short_title
    object.title.truncate(10)
  end
end