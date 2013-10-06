class HomeController < ApplicationController

  include SendMessageHelper

  def index
    @congressmen = Congressman.where(:in_office => 1, :has_picture => true).paginate(page: params[:page], per_page: 4)
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

    if request.method == "POST"
      message = request.POST['message']

      if user
        congressmen = []
        if user.has_facebook
          send_facebook(message, user, congressmen)
        end
        if user.has_twitter
          send_twitter(message, user, congressmen)
        end
        if true
          send_phone(message, user, congressmen)
        end
        congressmen.each do |cm|
          Message.create_from_message_user_congressman(message, user, cm)
        end
      else
        # should not reach here
      end

      render "send_message_success.html"
    else
      @disabled = {
        :facebook => true,
        :twitter => true,
        :phone => true,
        :email => true,
      }
      @is_connected = false

      if user
        @disabled[:phone] = false
        @disabled[:facebook] = ! user.has_facebook
        @disabled[:twitter] = ! user.has_twitter
        @disabled[:email] = ! user.has_email
        @is_connected = true
      end

      @message = get_last_message

      render "send_message_form.html"
    end
  end


  def save_message
    if request.method == "POST"
      if request.POST.include?("message")
        set_last_message(request.POST['message'])
      end
    end
  end


  def phone_endpoint
     @message = request.GET['message']
     render "phone_endpoint.xml.erb",
       :content_type => "application/xml",
       :layout => false
  end

end
