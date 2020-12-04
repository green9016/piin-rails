require 'rails_helper'

describe StatsDataService do
  
  before :each do
    @pre_month_diff = (Date.today - 1.month).beginning_of_month..(Date.today - 1.month).end_of_month
    @cur_month_diff = Date.today.beginning_of_month..Date.today.end_of_month
    @service = StatsDataService.new
  end

  describe '#diff_results_count' do
    context 'diff_results_count to Post' do
      post_diff = ( Post.where(created_at: @cur_month_diff).count -
        Post.where(created_at: @pre_month_diff).count )
      
      it { expect(@service.diff_results_count(Post)).to equal(post_diff) }  
    end

    context 'diff_results_count to User' do
      user_diff = ( User.where(created_at: @cur_month_diff).count -
        User.where(created_at: @pre_month_diff).count )
      
      it { expect(@service.diff_results_count(User)).to equal(user_diff) }  
    end

    context 'diff_results_count to Pin' do
      pin_diff = ( Pin.where(created_at: @cur_month_diff).count -
        Pin.where(created_at: @pre_month_diff).count )
      
      it { expect(@service.diff_results_count(Pin)).to equal(pin_diff) }  
    end

    context 'diff_results_count to Offer' do
      offer_diff = ( Offer.where(created_at: @cur_month_diff).count -
        Offer.where(created_at: @pre_month_diff).count )
      
      it { expect(@service.diff_results_count(Offer)).to equal(offer_diff) }  
    end
  end
  
  describe '#diff_active_results_count' do
    context 'diff_active_results_count to Post' do
      post_active_diff = ( Post.active.where(created_at: @cur_month_diff).count -
        Post.active.where(created_at: @pre_month_diff).count )
      
      it { expect(@service.diff_active_results_count(Post)).to equal(post_active_diff) }  
    end

    context 'diff_active_results_count to Pin' do
      pin_active_diff = ( Pin.active.where(created_at: @cur_month_diff).count -
        Pin.active.where(created_at: @pre_month_diff).count )
      
      it { expect(@service.diff_active_results_count(Pin)).to equal(pin_active_diff) }  
    end

    context 'diff_active_results_count to User' do
      user_active_diff = ( User.active.where(created_at: @cur_month_diff).count -
        User.active.where(created_at: @pre_month_diff).count )
      
      it { expect(@service.diff_active_results_count(User)).to equal(user_active_diff) }  
    end
  end

  describe '#pre_month_diff' do
    let(:result) { @service.instance_eval{ pre_month_diff } }
    
    it { expect(result.class).to eq(Range) }
    it { expect(result).to eq(@pre_month_diff) }
  end

  describe '#cur_month_diff' do
    let(:result) { @service.instance_eval{ cur_month_diff } }
    
    it { expect(result.class).to eq(Range) }
    it { expect(result).to eq(@cur_month_diff) }
  end
end
