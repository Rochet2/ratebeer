class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by username: params[:username]
    if user and user.authenticate params[:password]
      session[:user_id] = user.id
      redirect_to user, notice: "Welome back!"
    else
      redirect_to :back, notice: "Username or password does not match"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root
  end

end
