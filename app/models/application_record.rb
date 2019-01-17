class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :today_created, -> { where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day) }
end
