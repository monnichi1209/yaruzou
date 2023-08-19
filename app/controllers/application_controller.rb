class ApplicationController < ActionController::Base

  protected

  def after_sign_in_path_for(resource)
    role_selection_path
  end
end
