# frozen_string_literal: true

class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def send_payment_history_email(user, csv)
    @user = user
    attachments["payment_history-#{Date.today}.csv"] = {
      mime_type: 'text/csv', content: csv
    }
    mail(to: @user.email, subject: 'Payment History')
  end
end
