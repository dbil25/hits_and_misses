class ApplicationController < ActionController::Base
  include ActionView::RecordIdentifier
  include ActiveModel::Conversion
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, if: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def current_member
    current_user.members.find_by(team: Team.find_by(name: Apartment::Tenant.current))
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end

  def after_sign_out_path_for(user)
    new_user_session_url(subdomain: nil)
  end
end
