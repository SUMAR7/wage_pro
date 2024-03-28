class SalarySlipGenerator
  attr_accessor :pdf, :employee, :slip, :organization

  def initialize(salary_slip, organization)
    @slip = salary_slip
    @organization = organization
    @employee = salary_slip.user
    @pdf = Prawn::Document.new(page_size: 'A4')
  end

  def generate
    items = [['Salary Slip', 'Company', 'Employee']]
    column_widths = { 0 => 200, 1 => 150, 2 => 150 }
    @pdf.table(items, header: true, row_colors: %w[e2e2e2], column_widths: column_widths,
               cell_style: { size: 12, align: :left, border_width: 0 })

    items = []

    items << [
      slip.for_month.strftime('%B, %Y'),
      organization.name,
      employee.name
    ]

    designations = organization.department_employees.where(user_id: employee.id).pluck(:designation).uniq
    items << [
      "Issue date: #{slip.issue_date.strftime('%d %m, %Y')}",
      "",
      designations.join(' | ')
    ]

    items << [
      "",
      "",
      "#{employee.user_profile.address || 'Employee address'} - #{employee.user_profile.nationality || 'Nationality'}"
    ]

    items << [
      "",
      "",
      "Identification: #{employee.user_profile.identification_type || 'Identification type'}, #{employee.user_profile.identification_number || 'Identification number'}"
    ]

    @pdf.table(items, header: true, row_colors: %w[ffffff], column_widths: column_widths,
               cell_style: { size: 8, align: :left, border_width: 0 })

    @pdf.move_down 10

    @pdf.stroke do
      @pdf.horizontal_rule
      @pdf.stroke_color 'e2e2e2'
      @pdf.line_width 0.1
    end

    @pdf.move_down 10

    @pdf.text "Earnings", align: :left, style: :bold, size: 15

    @pdf.move_down 10

    items = [['', 'Amount']]
    column_widths = { 0 => 350, 1 => 150 }

    @pdf.table(items, header: true, row_colors: %w[e2e2e2], column_widths: column_widths,
                cell_style: { size: 12, align: :left, border_width: 0 })

    items = []
    items << [
      "Basic Salary",
      "#{slip.currency} #{slip.basic_salary / 100}",
    ]

    @pdf.table(items, header: true, row_colors: %w[ffffff], column_widths: column_widths,
                cell_style: { size: 10, align: :left, border_width: 0 })
    @pdf.move_down 10

    @pdf.stroke do
      @pdf.horizontal_rule
      @pdf.stroke_color 'e2e2e2'
      @pdf.line_width 0.1
    end

    @pdf.move_down 15

    @pdf.text "Bonus", align: :left, style: :bold, size: 15

    @pdf.move_down 10

    items = []

    items << [
      "Total Bonus (+)",
      "#{slip.currency} #{slip.total_bonus / 100}",
    ]

    @pdf.table(items, header: true, row_colors: %w[ffffff], column_widths: column_widths,
               cell_style: { size: 10, align: :left, border_width: 0 })

    @pdf.move_down 10

    @pdf.stroke do
      @pdf.horizontal_rule
      @pdf.stroke_color 'e2e2e2'
      @pdf.line_width 0.1
    end

    @pdf.move_down 15

    @pdf.text "Deductions", align: :left, style: :bold, size: 15

    @pdf.move_down 10

    items = []

    items << [
      "Total Deductions (-)",
      "#{slip.currency} #{slip.total_deductions / 100}",
    ]

    @pdf.table(items, header: true, row_colors: %w[ffffff], column_widths: column_widths,
               cell_style: { size: 10, align: :left, border_width: 0 })

    @pdf.move_down 10

    @pdf.stroke do
      @pdf.horizontal_rule
      @pdf.stroke_color 'e2e2e2'
      @pdf.line_width 0.1
    end

    @pdf.move_down 15

    items = [['Net Salary', "#{slip.currency} #{slip.net_salary / 100}"]]
    column_widths = { 0 => 350, 1 => 150 }

    @pdf.table(items, header: false, row_colors: %w[e2e2e2], column_widths: column_widths,
               cell_style: { size: 12, align: :left, border_width: 0 })


    @pdf.move_down 300

    @pdf.stroke do
      @pdf.horizontal_rule
      @pdf.stroke_color 'e2e2e2'
      @pdf.line_width 0.1
    end

    @pdf.move_down 10
    @pdf.text "Created by WagePro!", align: :left, style: :bold, size: 8

    @pdf.move_down 20
    @pdf.text "* This is a system generated slip and does not require any physical signature or stamp.", align: :left, style: :normal, size: 8


    @pdf
  end
end
