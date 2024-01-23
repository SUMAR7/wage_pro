class Api::V1::OrganizationsController < Api::V1::ApiController
  def index
    @organizations = policy_scope(Organization)

    render json: @organizations.as_json(only: [:id, :name], include: {
      departments: {
        only: [:id, :name, :description, :employees_count],
        include: {
          department_employees: {
            only: [:id, :designation, :description],
            include: {
              user: {
                only: [:name, :email]
              }
            }
          }
        }
      }
    })
  end
end
