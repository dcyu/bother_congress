
Rails.application.config.middleware.use OmniAuth::Builder do
    provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'],
             :scope => 'email,publish_actions'
    provider :twitter, ENV['TWITTER_APP_ID'], ENV['TWITTER_APP_SECRET']
end
