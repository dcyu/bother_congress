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

  def get_twitter_access_token(auth)
    consumer = OAuth::Consumer.new(
      ENV['TWITTER_APP_ID'], ENV['TWITTER_APP_SECRET'],
      :site => "http://api.twitter.com"
    )
    token_hash = {
      :oauth_token => auth.token,
      :oauth_token_secret => auth.secret 
    }
    access_token = OAuth::AccessToken.from_hash(consumer, token_hash)
    return access_token
  end

  def send_twitter(message, user, congressmen)
    auth = Authorization.find_by_provider_and_user_id('twitter', user.id)
    access_token = get_twitter_access_token(auth)
    url = "https://api.twitter.com/1.1/statuses/update.json"
    errors = successes = 0
    congressmen.map(&:twitter_id).compact.each do |twitter_id|
      data = {
        :status => message + " @" + twitter_id
      }
      response = access_token.post(url, data)
      if response.code != 200
        errors += 1
      else
        successes += 1
      end
    end

    # if there were no successes and some errors,
    # there's probably an issue with the auth token, so delete it
    if errors > 0 && successes == 0
      auth.delete()
    end
  end

  def send_phone(message, user, congressmen)
    congressmen.each do |cm|
      if (!cm.phone.nil?) and (!cm.phone.empty?)
        personal_message = "Hello " + cm.firstname + " " + cm.lastname + "."
        personal_message += user.name + " has a message for you. " + message
        url = url_for(:controller => 'home', :action => 'phone_endpoint', :only_path => false)
        url += "?message=" + Rack::Utils.escape(personal_message)
        data = {
          'Url' => url,
          'Method' => 'GET',
          'From' => ENV['TWILIO_PHONE_NUMBER'],
          'To' => cm.phone,
        }
        auth = {
          :username => ENV['TWILIO_ACCOUNT_SID'],
          :password => ENV['TWILIO_ACCOUNT_SECRET'],
        }
        url = "https://api.twilio.com/2010-04-01/Accounts/#{ENV['TWILIO_ACCOUNT_SID']}/Calls"
        response = HTTParty.post(url, :body => data, :basic_auth => auth)
      end
    end
  end

  def send_email(message, user, congressmen)
    congressmen.each do |cm|
      if !cm.email.blank?
        CongressMailer.send_message(message, user, cm).deliver!
      end
    end
  end

end
