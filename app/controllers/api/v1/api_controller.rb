class Api::V1::ApiController < ActionController::Base
  include Pundit::Authorization

  # Calls authenticate_with_api_token! method to ensure authentication with API token before
  # any action in this controller or any of its descendants.
  before_action :authenticate_with_api_token!

  # Allow access to the current user from within the controller and its descendants.
  attr_reader :current_user

  private

  # Authenticate the request using an API token.
  def authenticate_with_api_token!
    authenticate_or_request_with_http_token do |token, _options|
      # Find the user associated with the provided API token.
      @current_user = User.find_by(api_key: token)

      # If a valid user is found, continue with the request.
      # If not, render an unauthorized response.
      @current_user || render_unauthorized
    end
  end

  # Render an unauthorized response with a JSON error message.
  def render_unauthorized
    render json: { error: 'Invalid API Key' }, status: :unauthorized
  end
end
