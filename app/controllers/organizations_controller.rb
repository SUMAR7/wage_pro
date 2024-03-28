class OrganizationsController < ApplicationController
  layout 'dashboard'

  def index
    @pagy, @organizations = pagy(policy_scope(Organization))
  end

  def show
    @organization = policy_scope(Organization).includes(:departments).find(params[:id])
  end

  def new
    @organization = Organization.new
    authorize @organization
  end

  def edit
    @organization = policy_scope(Organization).find(params[:id])
    authorize @organization
  end

  def create
    @organization = current_user.organizations.new(organization_params)
    authorize @organization

    if @organization.save
      redirect_to organizations_path, notice: 'Organization was successfully created.'
    else
      flash[:alert] = @organization.errors.full_messages.join(', ')
      render :new
    end
  end

  def update
    @organization = policy_scope(Organization).find(params[:id])
    authorize @organization

    if @organization.update(organization_params)
      redirect_to organization_path(@organization), notice: 'Organization was successfully updated.'
    else
      flash[:alert] = @organization.errors.full_messages.join(', ')
      render :edit
    end
  end

  def destroy
    @organization = policy_scope(Organization).find(params[:id])
    @organization.destroy

    redirect_to organizations_path, notice: 'Organization was successfully deleted.'
  end

  private

  def organization_params
    params.require(:organization).permit(:name, :salary_distribution_day)
  end
end
