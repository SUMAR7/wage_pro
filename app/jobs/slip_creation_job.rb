class SlipCreationJob < ApplicationJob
  queue_as :default

  def perform
    date = Date.current

    Organization.where(salary_distribution_day: date.day).find_each do |organization|
      organization.employees.uniq.each do |user|

        department_employees = organization.department_employees.where(user_id: user.id)
        base_salary = department_employees.sum(&:base_salary)
        bonus = department_employees.sum(&:bonus)
        tax = department_employees.sum(&:tax)
        deductions = department_employees.sum(&:other_deductions)
        total_deductions = tax + deductions
        net_salary = base_salary + bonus - total_deductions

        SalarySlip.create!(
          user: user,
          organization_id: organization.id,
          for_month: date.beginning_of_month,
          issue_date: date,
          basic_salary: base_salary,
          total_deductions: total_deductions,
          total_bonus: bonus,
          net_salary: net_salary,
          currency: organization.currency
        )
      end
    end
  end
end
