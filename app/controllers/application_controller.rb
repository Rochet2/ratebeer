class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  def current_user
    return nil if session[:user_id].nil?
    u = User.find_by id: session[:user_id]
    return nil if u.nil? or u.inactive?
    return u
  end

  def ensure_that_signed_in
    redirect_to signin_path, notice:'you should be signed in' if current_user.nil?
  end

  def ensure_that_admin
    self.ensure_that_signed_in
    redirect_to :back, notice:'you need admin access' if not current_user.admin?
  end
end
