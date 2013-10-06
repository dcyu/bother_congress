module SendMessageHelper

  def get_facebook_access_token
    url = "https://graph.facebook.com/oauth/access_token?"\
          "client_id=#{ENV['FACEBOOK_APP_ID']}"\
          "&client_secret=#{ENV['FACEBOOK_APP_SECRET']}"\
          "&grant_type=client_credentials"
    response = HTTParty.get(url)
    return response.body.split('=')[1]
  end

  def send_facebook(message, user, congressmen)
    auth = Authorization.find_by_provider_and_user_id('facebook', user.id)
    token = get_facebook_access_token()
    ids = congressmen.map{|x| x.facebook_id}.select{|x| x}
    data = {
      "message" => message + " " + ids.map{|x| "@[#{x}]" }.join(" "),
      "access_token" => token,
    }
    url = "https://graph.facebook.com/#{auth.uid}/feed"
    response = HTTParty.post(url, { :body => data })

    # detect if failure. if so, remove facebook Authorization
    # so that the user has to re-authorize in the future
    j = JSON.parse(response.body)
    if !j.has_key?('id')
      auth.delete()
    end
  end

  def send_twitter(user, congressmen)
    auth = Authorization.find_by_provider_and_user_id('twitter', user.id)
  end

  def send_phone(user, congressmen)
  end

  def send_email(user, congressmen)
  end

end
