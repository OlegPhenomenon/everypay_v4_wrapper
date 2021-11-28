require_relative '../../lib/everypay_v4_wrapper/link_builder'

LINKPAY_TOKEN = 'some-token'
LINKPAY_PREFIX = 'https://igw-demo.every-pay.com/lp'
KEY = 'some-secret-key'

RSpec.describe EverypayV4Wrapper::LinkBuilder do
  before do
    money = Money.new(@sum, 'EUR')
    price = money&.format(symbol: nil, thousands_separator: false, decimal_mark: '.')

    @link_builder = described_class.new(params: {
      transaction_amount: price,
      custom_field_1: 'this_is_description',
      invoice_number: '122',
      linkpay_token: LINKPAY_TOKEN,
      order_reference: '233',
      customer_name: 'oleg_hasjanov',
      customer_email: 'oleg.phenomenon@gmail.com',
    }, key: KEY)
  end

  describe 'link builder' do
    it 'should build link' do
      link = @link_builder.build_link

      expect(link).to include(LINKPAY_PREFIX)
      expect(link).to include(LINKPAY_TOKEN)
      expect(link).to include('oleg.phenomenon@gmail.com')

      expect(link).not_to include(KEY)
    end
  end
end