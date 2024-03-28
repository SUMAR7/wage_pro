class UserPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.has_role?(:admin) || user.has_role?(:manager)
        organizations = OrganizationPolicy::Scope.new(user, Organization).resolve
        department_ids = Department.where(organization_id: organizations.pluck(:id)).pluck(:id)
        scope.joins(:department_employees).where(department_employees: { department_id: department_ids })
      else
        manager_scope.presence || employee_scope
      end.distinct
    end

    private

    def manager_scope
      scope.joins(:department_employees).where(department_employees: { department_id: manager_department_ids })
    end

    def employee_scope
      scope.where(id: user.id)
    end

    def manager_department_ids
      department_employees = user.department_employees.where(user_id: user.id)
      department_employees.map { |de| de.department_id if de.has_role?(:manager) }
    end

    def admin_department_ids
      user.department_employees.where(user_id: user.id)
    end
  end

  def show?
    # All users can view their profiles but only an admin can view all user profiles
    user.has_role?(:admin) || user.id == record.id
  end

  def create?
    user.has_role?(:admin) || department_employee&.has_role?(:admin) || department_employee&.has_role?(:manager)
  end

  def update?
    user.has_role?(:admin) || department_employee&.has_role?(:admin) || department_employee&.has_role?(:manager)
  end

  def new?
    create?
  end

  def edit?
    update?
  end

  def destroy?
    user.has_role?(:admin) || department_employee&.has_role?(:admin)
  end

  def department_employee
    user.department_employees.find_by(user_id: user.id)
  end
end
