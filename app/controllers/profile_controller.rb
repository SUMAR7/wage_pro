class ProfileController < ApplicationController
  layout 'dashboard'

  def show
    @user = User.find(params[:id])
    @user_profile = @user.user_profile
    @designations = @user.department_employees.pluck(:designation).compact.uniq
    @organizations = Organization.includes(departments: :department_employees).where(department_employees: { user_id: @user.id }).distinct

    authorize @user
  end

  def new_profile
    @user = User.find(params[:id])
    @user_profile = @user.build_user_profile
  end

  def edit_profile
    @user = User.find(params[:id])
    @user_profile = @user.user_profile
  end

  def create_new_profile
    @user = User.find(params[:id])
    @user_profile = @user.build_user_profile(user_profile_params)

    if @user_profile.save
      redirect_to profile_path(@user), notice: 'Profile was successfully created.'
    else
      render :new_profile
    end
  end

  def update_profile
    @user = User.find(params[:id])
    @user_profile = @user.user_profile

    if @user_profile.update(user_profile_params)
      redirect_to profile_path(@user), notice: 'Profile was successfully updated.'
    else
      render :edit_profile, alert: @user_profile
    end
  end

  private

  def user_profile_params
    params.require(:user_profile).permit(
      :birthday, :gender, :address,
      :nationality, :is_local_resident, :identification_type,
      :identification_number, :phone, :is_disable,
      :disability_description, :alternate_email, :alternate_phone,
      :emergency_contact_name, :emergency_contact_phone)
  end
end
