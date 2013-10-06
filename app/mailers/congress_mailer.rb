class CongressMailer < ActionMailer::Base
  def test_email
    mail(
      :to => ["pashamur@gmail.com", "hogbait@gmail.com"],
      :from => "bothercongress+testing@gmail.com",
      :return_path => "pashamur@gmail.com",
      :subject => "Testing email delivery",
      :body => "This is a test email, please ignore"
    )
  end
end