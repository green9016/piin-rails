# frozen_string_literal: true

class BusinessMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def send_business_payment_history(business, csv)
    @business = business
    attachments["payment_history-#{Date.today}.csv"] = {
        mime_type: 'text/csv', content: csv
    }
    mail(to: @business.email, subject: 'Payment History')
  end
end
