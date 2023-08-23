class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :hide_sidebar, only: [:new, :edit, :update]

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email_confirmation])
  end

    def hide_sidebar
      @hide_sidebar = true
    end
  end
 