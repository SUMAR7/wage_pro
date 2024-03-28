class EmployeesController < ApplicationController
  layout 'dashboard'

  before_action :set_employee, only: %i[show edit update destroy]

  def index
    employees = if params[:q].present?
                  policy_scope(User).search_by_name_or_email(params[:q]).with_pg_search_rank
                else
                  policy_scope(User)
                end

    @pagy, @employees = pagy(employees)
  end

  def show
    authorize @employee
  end

  def new
    @employee = User.new
    @employee.department_employees.build

    authorize @employee
  end

  def edit
    authorize @employee
  end

  def create
    @employee = User.new(employee_params)

    authorize @employee

    if @employee.save
      redirect_to employees_path, notice: 'Employee was successfully created.'
    else
      flash[:alert] = @employee.errors.full_messages.join(', ')
      render :new
    end
  end

  def update
    authorize @employee

    if @employee.update(employee_params)
      redirect_to employee_path(@employee), notice: 'Employee was successfully updated.'
    else
      flash[:alert] = @employee.errors.full_messages.join(', ')
      render :edit
    end
  end

  def destroy
    authorize @employee

    @employee.destroy

    redirect_to employees_path, notice: 'Employee was successfully destroyed.'
  end

  private

  def employee_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role, department_employees_attributes: [:department_id, :designation, :description, :department_role])
  end

  def set_employee
    @employee = User.find(params[:id])
  end
end
