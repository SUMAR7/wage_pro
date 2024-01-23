class User < ApplicationRecord
  resourcify
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_secure_token :api_key

  has_many :organizations, foreign_key: 'admin_user_id', dependent: :destroy

  has_many :department_employees, dependent: :destroy
  has_many :departments, through: :department_employees
end
