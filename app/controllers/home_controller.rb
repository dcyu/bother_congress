class HomeController < ApplicationController

  include SendMessageHelper

  def index
    @congressmen = Congressman.where(:in_office => 1, :has_picture => true).paginate(page: params[:page], per_page: 4)
    @init_state = get_page_state
  end

  def search
    results = Congressman.where("in_office = 1 AND firstname || ' ' || lastname ~* ?", "[[:<:]]"+params[:q])

    if request.xhr?
      return render :json => results[0..3].to_json(:only => [:title, :firstname, :lastname, :party, :state], :methods => [:picture_url])
    else
      @congressmen = results.paginate(page: params[:page], per_page: 4)

      render :action => 'index'
    end
  end

  def names
    render :json => Congressman.where(in_office: 1).select([:firstname, :lastname]).all.map(&:fullname)
  end

  def send_message
    user = get_user
    state = get_page_state
    if user
      @congressmen = session[:congressmen].map{|x| Congressman.find(x)}
      message = state['message']
      if user.has_facebook and state['facebook_enabled'] == true
        send_facebook(message, user, @congressmen)
      end
      if user.has_twitter and state['twitter_enabled'] == true
        send_twitter(message, user, @congressmen)
      end
      if state['phone_enabled'] == true
        send_phone(message, user, @congressmen)
      end
      if user.has_email and state['email_enabled'] == true
        send_email(message, user, @congressmen)
      end
      @congressmen.each do |cm|
        Message.create_from_message_user_congressman(message, user, cm)
      end
      session[:old_congressmen] = session[:congressmen]
      clear_page_state()
      redirect_to url_for(:controller => :home, :action => :send_message_success)
    else
      redirect_to url_for(:controller => :home, :action => :index)
    end
  end

  def send_message_success
    @congressmen = session[:old_congressmen].map{|x| Congressman.find(x)}
    render "send_message_success"
  end

  def save_state
    state = JSON.parse(request.body.read)
    save_page_state(state)
    render json: {"status" => "success"}
  end


  def phone_endpoint
    @message = request.GET['message']
    render "phone_endpoint.xml.erb",
      :content_type => "application/xml",
      :layout => false
  end

  def about
  end

end
