class SalarySlipsController < ApplicationController
  layout 'dashboard'
  before_action :set_organization
  before_action :set_employee

  def index
    @pagy, @salary_slips = pagy(@employee.salary_slips)
  end

  def show
    @salary_slip = @employee.salary_slips.find(params[:id])

    pdf = SalarySlipGenerator.new(@salary_slip, @organization).generate
    file_name = "salary_slip_#{@salary_slip.for_month}.pdf"

    send_data(
      pdf.render,
      filename: file_name,
      type: 'application/pdf',
      disposition: 'inline'
    )
  end

  private

  def set_organization
    @organization = Organization.find(params[:organization_id])
  end

  def set_employee
    @employee = @organization.employees.find(params[:employee_id])
  end
end
