class Organization < ApplicationRecord
  belongs_to :admin_user, class_name: 'User'

  validates :name, presence: true, uniqueness: true
  validate :admin_user_must_be_admin

  private

  def admin_user_must_be_admin
    errors.add(:admin_user, "must be an admin") unless admin_user&.has_role?(:admin)
  end
end
