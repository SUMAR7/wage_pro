class Organization < ApplicationRecord
  belongs_to :admin_user, class_name: 'User'

  has_many :departments, dependent: :destroy
  has_many :department_employees, through: :departments
  has_many :employees, through: :department_employees, source: :user
  has_many :salary_slips, dependent: :destroy

  # we will add weekly and bi-weekly in the future
  enum salary_distribution_type: %w[monthly].index_by(&:to_s)

  after_commit :create_admin_department, on: :create

  validates :salary_distribution_day, presence: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 31 }
  validates :name, presence: true, uniqueness: { scope: :admin_user_id }
  validate :admin_user_must_be_admin

  private

  def create_admin_department
    departments.create(name: 'Administration', description: 'Top level administration of an organization')
  end

  def admin_user_must_be_admin
    errors.add(:admin_user, "must be an admin") unless admin_user&.has_role?(:admin)
  end
end
