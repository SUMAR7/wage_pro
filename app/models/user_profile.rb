class UserProfile < ApplicationRecord
  belongs_to :user

  enum gender: %w[male female other].index_by(&:to_s)
  enum identification_type: %w[passport national_id].index_by(&:to_s)
end
