require_relative '../../lib/everypay_v4_wrapper/money_transfer'

RSpec.describe EverypayV4Wrapper::MoneyTransfer do

  describe 'translate money to another format' do
    before do
      @money = described_class.new(200000)
    end

    it 'should separe cents to whole amount' do
      expect(@money.transfer_it).to eq('2000.00')
    end

    it 'should add separate into sum' do
      price = @money.transfer_it(decimal_mark: ',')
      expect(price).to eq('2000,00')
    end

    it 'should add separator in thousands' do
      price = @money.transfer_it(thousands_separator: ' ')
      expect(price).to eq('2 000.00')
    end

    it 'should add currency' do
      price = @money.transfer_it(symbol: '€')
      expect(price).to eq('€2000.00')
    end
  end

end