class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_filter :configure_permitted_parameters
  protect_from_forgery with: :exception

  def configure_permitted_parameters
    if devise_controller?
      devise_parameter_sanitizer.for(:sign_up) do |u|
        u.permit(:name, :email, :password,:password_confirmation,
          :student_id)
      end

    end
  end
end
