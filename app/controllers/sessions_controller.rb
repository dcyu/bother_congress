class SessionsController < ApplicationController
  def new
  end

  def create
    auth_hash = request.env['omniauth.auth']

    if session[:user_id]
      # Means our user is signed in. Add the authorization to the user
      User.find(session[:user_id]).add_provider(auth_hash)
    else
      # Log him in or sign him up
      auth = Authorization.find_or_create(auth_hash)

      # Create the session
      session[:user_id] = auth.user.id
    end

    state = get_page_state
    if auth_hash["provider"] == 'facebook'
      state['facebook_enabled'] = true
    elsif auth_hash["provider"] == 'twitter'
      state['twitter_enabled'] = true
    end
    user = User.find(session[:user_id])
    if user.email and !state['email'].empty?
      state['email'] = user.email
    end
    save_page_state(state)

    redirect_to url_for(:controller => :home, :action => :index)
  end

  def failure
    render :text => "Sorry, but you didn't allow access to our app!"
  end

  def destroy
    session[:user_id] = nil
    render :text => "You've logged out!"
  end

end
