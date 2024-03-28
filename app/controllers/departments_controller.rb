class DepartmentsController < ApplicationController
  layout 'dashboard'

  before_action :set_organization

  def index
    @departments = policy_scope(@organization.departments)
  end

  def show
    @department = @organization.departments.find(params[:id])
    authorize @department
  end

  def new
    @department = @organization.departments.new
    authorize @department
  end

  def edit
    @department = @organization.departments.find(params[:id])
    authorize @department
  end

  def create
    @department = @organization.departments.new(department_params)
    authorize @department

    if @department.save
      redirect_to organization_path(@organization), notice: 'Department was successfully created.'
    else
      flash[:alert] = @department.errors.full_messages.join(', ')
      render :new
    end
  end

  def update
    @department = @organization.departments.find(params[:id])
    authorize @department

    if @department.update(department_params)
      redirect_to organization_department_path(@organization, @department), notice: 'Department was successfully updated.'
    else
      flash[:alert] = @department.errors.full_messages.join(', ')
      render :edit
    end
  end

  def destroy
    @department = @organization.departments.find(params[:id])
    authorize @department

    @department.destroy

    redirect_to organization_departments_path(@organization), notice: 'Department was successfully deleted.'
  end

  private

  def department_params
    params.require(:department).permit(:name, :description)
  end

  def set_organization
    @organization = policy_scope(Organization).find(params[:organization_id])
  end
end
