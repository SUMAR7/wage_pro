class OrganizationPolicy < ApplicationPolicy

  # The Scope class defines the policy for handling queries on the Organization model.
  class Scope < ApplicationPolicy::Scope

    # The resolve method determines the scope of Organization records accessible to a user.
    def resolve
      # Check if the user has the admin role.
      if user.has_role?(:admin)
        # If the user is an admin, apply the admin_scope.
        admin_scope
      else
        # If the user is not an admin, apply the non_admin_user_scope.
        non_admin_user_scope
      end.distinct # distinct is used to remove duplicate records.
    end

    private

    # Defines the scope for non-admin users.
    def non_admin_user_scope
      # Joins the organizations table with the departments table and filters organizations
      # based on the user's department_ids, allowing access to relevant records.
      scope.joins(:departments).where(departments: { id: user.department_ids })
    end

    # Defines the scope for admin users.
    def admin_scope
      # Joins the organizations table with the departments table and filters organizations
      # based on the admin_user_id or the non-admin user scope.
      scope.joins(:departments).where(admin_user_id: user.id).or(non_admin_user_scope)
    end
  end

  def update?
    # Check if the user is an admin or the owner of the organization.
    user.has_role?(:admin) || record.admin_user_id == user.id
  end

  def create?
    # Check if the user is an admin.
    user.has_role?(:admin)
  end

  def new?
    create?
  end

  def edit?
    update?
  end

  def destroy?
    # Check if the user is an admin or the owner of the organization.
    user.has_role?(:admin) || record.admin_user_id == user.id
  end
end

