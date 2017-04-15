class InvitationMailer < ActionMailer::Base
  def new_employee_invite(invite, url)
    @invite = invite
    @url = url
    mail({from: 'info@servicehero.com', to: @invite.email, subject: "INVITATION TOKEN"})
  end
end
