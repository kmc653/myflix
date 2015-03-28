class SessionsController < ApplicationController
  
  def new
    redirect_to home_path if current_user
  end

  def create
    user = User.where(email: params[:email]).first
    if user && user.authenticate(params[:password])
      if user.active?
        session[:user_id] = user.id
        redirect_to home_path, notice: "Your're signed in, enjoy!"
      else
        flash[:error] = "You account has been suspended, Please contact customer service."
        redirect_to sign_in_path
      end
    else
      flash[:error] = "Invalid email or password."
      redirect_to sign_in_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "You're signed out."
  end
end