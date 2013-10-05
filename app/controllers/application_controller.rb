class ApplicationController < ActionController::Base
  protect_from_forgery

  def get_user
    if !session.include?(:user_id)
      return nil
    else
      return User.find(session[:user_id])
    end
  end

  def get_last_message
    if session.include?(:last_message)
      return session[:last_message]
    end
    return ""
  end

  def set_last_message(m)
    session[:last_message] = m
  end

end
