class HomeController < ApplicationController

  include SendMessageHelper

  def index
    @congressmen = Congressman.where(:in_office => 1, :has_picture => true).paginate(page: params[:page], per_page: 8)
  end

  def send_message
    user = get_user

    if request.method == "POST"
      message = request.POST['message']

      if user
        cm = []
        if user.has_facebook
          send_facebook(message, user, cm)
        end
      else
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

end
