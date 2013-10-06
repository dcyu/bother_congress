class ApplicationController < ActionController::Base
  protect_from_forgery

  def get_user
    if !session.include?(:user_id)
      return nil
    else
      return User.find(session[:user_id])
    end
  end

  def get_page_state
    state = session[:state]
    if state
      # check for a corrupted state
      good = true
      required_keys = ['message','page','facebook_enabled','twitter_enabled',
        'phone_enabled', 'email_enabled', 'email_address'];
      required_keys.each do |key|
        if !state.has_key?(key)
          good = false
        end
      end
      if good
        return state
      end
    end
    default_state = {
      'message' => "",
      'page' => 0,
      'facebook_enabled' => false,
      'twitter_enabled' => false,
      'phone_enabled' => false,
      'email_enabled' => false,
      'email_address' => "",
    }
    return default_state
  end

  def save_page_state(state)
    # TODO: validation?
    session[:state] = state
  end

  def clear_page_state
    session[:state] = {}
    session[:congressmen] = []
  end

end
