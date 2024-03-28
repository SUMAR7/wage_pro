class DepartmentEmployee < ApplicationRecord
  rolify :role_cname => 'DepartmentRole'
  belongs_to :department, counter_cache: :employees_count
  belongs_to :user

  attr_accessor :department_role

  validates :department, :user, presence: true
  validates :user_id, uniqueness: { scope: :department_id }

  validates :base_salary, numericality: { greater_than_or_equal_to: 0 }
  validates :tax, numericality: { greater_than_or_equal_to: 0 }
  validates :other_deductions, numericality: { greater_than_or_equal_to: 0 }
  validates :bonus, numericality: { greater_than_or_equal_to: 0 }

  delegate :name, to: :department, prefix: true
  delegate :name, to: :user, prefix: 'employee'
  delegate :email, to: :user, prefix: 'employee'

  accepts_nested_attributes_for :user

  after_commit :assign_department_role

  def assign_department_role
    if department_role.present? && !has_role?(department_role)
      roles.destroy_all # delete existing roles

      add_role(:"#{department_role}") if department_role.present?
    end
  end
end
