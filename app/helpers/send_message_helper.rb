module SendMessageHelper

  def get_facebook_access_token
    url = "https://graph.facebook.com/oauth/access_token?"\
          "client_id=#{ENV['FACEBOOK_APP_ID']}"\
          "&client_secret=#{ENV['FACEBOOK_APP_SECRET']}"\
          "&grant_type=client_credentials"
    response = HTTParty.get(url)
    return response.body.split('=')[1]
  end

  def send_facebook(message, user, congressman)
    auth = Authorization.find_by_provider_and_user_id('facebook', user.id)
    token = get_facebook_access_token()
    data = {
      "message" => message,
      "access_token" => token,
    }
    url = "https://graph.facebook.com/#{auth.uid}/feed"
    response = HTTParty.post(url, { :body => data })
  end

  def send_twitter(user, congressman)
  end

  def send_phone(user, congressman)
  end

  def send_email(user, congressman)
  end
end
