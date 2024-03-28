class User < ApplicationRecord
  include PgSearch::Model
  resourcify
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_secure_token :api_key

  attr_accessor :role # needed for the form

  has_many :organizations, foreign_key: 'admin_user_id', dependent: :destroy

  # all employees of an admin user from all organizations
  has_many :employees, -> { distinct }, through: :organizations
  has_one :user_profile, dependent: :destroy

  # all departments a user is part of
  has_many :department_employees, dependent: :destroy
  has_many :departments, through: :department_employees

  has_many :salary_slips, dependent: :destroy

  accepts_nested_attributes_for :department_employees
  accepts_nested_attributes_for :user_profile

  after_commit :assign_global_role

  pg_search_scope :search_by_name_or_email, against: [:name, :email], using: { tsearch: { prefix: true } }

  def assign_global_role
    if role.present? && !has_role?(role)
      roles.destroy_all # delete existing roles

      add_role(:"#{role}")
    end
  end
end
