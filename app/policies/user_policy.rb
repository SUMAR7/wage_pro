class UserPolicy < ApplicationPolicy
  def show?
    # All users can view their profiles but only an admin can view all user profiles
    user.has_role?(:admin) || user.id == record.id
  end
end
