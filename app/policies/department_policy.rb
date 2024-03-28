class DepartmentPolicy < ApplicationPolicy
  # The Scope class defines the policy for handling queries on the Organization model.
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.has_role?(:admin)
        admin_scope
      else
        non_admin_user_scope
      end.distinct
    end

    private

    def admin_scope
      scope.all
    end

    def non_admin_user_scope
      scope.where(id: user.department_ids)
    end
  end

  def update?
    user.has_role?(:admin) || department_employee&.has_role?(:admin) || department_employee&.has_role?(:manager)
  end

  def create?
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

  def show?
    user.has_role?(:admin) || department_employee&.has_role?(:admin) || department_employee&.has_role?(:manager) || department_employee&.has_role?(:employee)
  end

  private

  def department_employee
    record.department_employees.find_by(user_id: user.id)
  end
end
