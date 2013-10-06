class CongressMailer < ActionMailer::Base
  def send_message(m, user, congressman)
    @congressman = congressman
    @message = m 
    @user = user
    mail(
      :to => congressman.email,
      :from => user.email,
      :return_path => user.email,
      :subject => "#{user.name} has a message for you.",
    )
  end
end
