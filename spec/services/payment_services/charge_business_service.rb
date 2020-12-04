require 'rails_helper'

describe PaymentServices::ChargeBusiness do
  before :each do
    @business = create(:business)
    @amount_in_cents = 10
  end
  
  it 'service should not be null' do
    service = PaymentServices::ChargeBusiness.new(@business, @amount_in_cents)
    expect(service).not_to be_nil
  end
  
  it 'retuns an Hash' do
    ob = { amount: @amount_in_cents,
      currency: 'usd',
      customer: @business.stripe_customer_id,
      description: 'TODO: Add description'
    }
    
    allow(Stripe::Charge).to receive(:create).and_return(ob)
    service = PaymentServices::ChargeBusiness.new(@business, @amount_in_cents)
    
    expect(service.call.class).to eql(Hash)
  end
end
  