class DepartmentEmployee < ApplicationRecord
  belongs_to :department, counter_cache: :employees_count
  belongs_to :user

  validates :department, :user, presence: true
  validates :user_id, uniqueness: { scope: :department_id }

  delegate :name, to: :department, prefix: true
  delegate :name, to: :user, prefix: 'employee'
end
