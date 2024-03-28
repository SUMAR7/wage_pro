class DepartmentEmployeesController < ApplicationController
  layout 'dashboard'

  before_action :set_organization
  before_action :set_department

  def index
    @department_employees = policy_scope(@department.department_employees.includes(:user))
  end

  def show
    @department_employee = @department.department_employees.find(params[:id])
    authorize @department_employee
  end

  def new
    @department_employee = @department.department_employees.new
    authorize @department_employee

    @department_employee.build_user

    existing_employee_ids = @department.department_employees.pluck(:user_id)
    @employees = @organization.employees.where.not(id: existing_employee_ids)
  end

  def edit
    @department_employee = @department.department_employees.find(params[:id])
    authorize @department_employee

    @employee = @department_employee.user
  end

  def create
    @department_employee = @department.department_employees.new(department_employee_params)
    authorize @department_employee

    if @department_employee.save
      redirect_to organization_department_department_employees_path(@organization, @department), notice: 'Employee added to department.'
    else
      render :new
    end
  end

  def update
    @department_employee = @department.department_employees.find(params[:id])
    authorize @department_employee

    if @department_employee.update(department_employee_params)
      redirect_to organization_department_department_employees_path(@organization, @department), notice: 'Employee updated.'
    else
      render :edit
    end
  end

  def destroy
    @department_employee = @department.department_employees.find(params[:id])
    authorize @department_employee

    @department_employee.destroy

    redirect_to organization_department_department_employees_path(@organization, @department), notice: 'Employee removed from department.'
  end

  private

  def department_employee_params
    params.require(:department_employee).permit(:user_id, :designation, :description, :department_role, :base_salary, :tax, :other_deductions, :bonus, user_attributes: [:name, :email, :password, :password_confirmation, :role])
  end

  def set_organization
    @organization = policy_scope(Organization).find(params[:organization_id])
  end

  def set_department
    @department = @organization.departments.find(params[:department_id])
  end
end
