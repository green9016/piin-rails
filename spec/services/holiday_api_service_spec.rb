require 'rails_helper'

describe HolidayApiService do
  before :each do
    @params = {
           'country' => 'US',
           'year'    => 2019,
           'month'    => 7,
           'day'      => 4,
           'previous' => true,
           'upcoming' => true,
           'public'   => true,
           'pretty'   => true,
        }
    @service = HolidayApiService.new    
  end

  describe '#get_holiday_lists' do
    context 'when params of get_holiday_list is not null' do
      let(:result) { @service.get_holiday_lists(@params) }
      it { expect(result.class).to eq(String) }
      it { expect(result).not_to be_nil }
      it { expect(result['country']).to be_truthy }
      it { expect(result['year']).to be_truthy }
      it { expect(result['month']).to be_truthy }
      it { expect(result['previous']).to be_truthy }
      it { expect(result['upcoming']).to be_truthy }
      it { expect(result['public']).to be_truthy }
      it { expect(result['pretty']).to be_truthy }
    end
  end
end