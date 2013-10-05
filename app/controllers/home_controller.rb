class HomeController < ApplicationController
  def index
  end

  def send_message
    if request.method == "POST"
      render "send_message_success.html"
    else
      @disabled = {
        :facebook => true,
        :twitter => true,
        :phone => true,
        :email => true,
      }
      @is_connected = false

      user = get_user
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
