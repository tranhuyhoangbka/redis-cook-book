class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  helper_method :base_file_name

  private
  def base_file_name path
    path.split("/").last.sub /\..+/, ""
  end
end
