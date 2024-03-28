class Department < ApplicationRecord
  belongs_to :organization

  validates :name, presence: true,  uniqueness: { scope: :organization_id }
  validates :organization, :description, presence: true

  has_many :department_employees, dependent: :destroy
  has_many :employees, through: :department_employees, source: :user

  after_commit :add_admin_to_department, if: -> { name == 'Administration' }, on: :create

  def add_user(user_id)
    department_employees.create(user_id: user_id)
  end

  private

  def add_admin_to_department
    add_user(organization.admin_user_id)
  end
end
