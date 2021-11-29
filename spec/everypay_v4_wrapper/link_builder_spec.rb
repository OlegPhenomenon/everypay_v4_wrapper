require_relative '../../lib/everypay_v4_wrapper'

LINKPAY_TOKEN = 'some-token'
LINKPAY_PREFIX = 'https://igw-demo.every-pay.com/lp'
KEY = 'some-secret-key'

RSpec.describe EverypayV4Wrapper::LinkBuilder do
  describe 'link builder' do
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

    it 'should build link' do
      link = @link_builder.build_link

      expect(link).to include(LINKPAY_PREFIX)
      expect(link).to include(LINKPAY_TOKEN)
      expect(link).to include('oleg.phenomenon@gmail.com')

      expect(link).not_to include(KEY)
    end
  end

  describe 'money parsing' do
    before do
      @params = {
        transaction_amount: '2000',
        custom_field_1: 'this_is_description',
        invoice_number: '122',
        linkpay_token: LINKPAY_TOKEN,
        order_reference: '233',
        customer_name: 'oleg_hasjanov',
        customer_email: 'oleg.phenomenon@gmail.com'
      }
    end

    it 'should not translate money by default' do
      @link = described_class.new(params: @params, key: KEY)
      expect(@link.build_link).to include('transaction_amount=2000')
    end

    it 'should translate money if I set flag' do
      @link = described_class.new(params: @params, currency_translation: { field_name: 'transaction_amount', flag: true}, key: KEY)
      expect(@link.build_link).to include('transaction_amount=20.00')
    end

    it 'should translate money if I set flag and no default field' do
      @params[:amount] = '2000'
      @link = described_class.new(params: @params, currency_translation: { field_name: 'amount', flag: true}, key: KEY)
      expect(@link.build_link).to include('amount=20.00')
    end

    it 'should translate money if I set flag and separete' do
      @link = described_class.new(params: @params, currency_translation: { field_name: 'transaction_amount',
                                                                           flag: true,
                                                                           decimal_mark: ','}, key: KEY)
      expect(@link.build_link).to include('transaction_amount=20,00')
    end
  end

  describe 'separate params value' do
    before do
      @params = {
        transaction_amount: '2000',
        custom_field_1: 'This is description ',
        invoice_number: '122',
        linkpay_token: LINKPAY_TOKEN,
        order_reference: '233',
        customer_name: ' Oleg  Hasjanov',
        customer_email: 'oleg.phenomenon@gmail.com'
      }
    end

    it 'should separate params value by _' do
      @link = described_class.new(params: @params, currency_translation: { field_name: 'transaction_amount',
                                                                           flag: true,
                                                                           decimal_mark: ','},
                                                    key: KEY,
                                                    separator: {
                                                      flag: true,
                                                      symbol: '_' })

      expect(@link.build_link).to include('custom_field_1=this_is_description')
      expect(@link.build_link).to include('customer_name=oleg_hasjanov')
    end
  end

  describe 'should allow to set up parms in initializer by configuraion' do
    before do
      @params = {
        transaction_amount: '2000',
        custom_field_1: 'this_is_description',
        invoice_number: '122',
        linkpay_token: LINKPAY_TOKEN,
        order_reference: '233',
        customer_name: 'oleg_hasjanov',
        customer_email: 'oleg.phenomenon@gmail.com'
      }
    end

    it 'should to formatted transaction amount field' do
      EverypayV4Wrapper.configure do |config|
        config.currency_translation_flag = true
        config.currency_translation_field = 'transaction_amount'
        config.currency_translation_currency = 'EUR'
        config.currency_translation_symbol = nil
        config.currency_translation_decimal_mark = '.'
        config.currency_translation_thousands_separator = false
      end

      @link = described_class.new(key: KEY, params: @params)
      expect(@link.build_link).to include('transaction_amount=20.00')

      EverypayV4Wrapper.configure do |config|
        config.currency_translation_flag = false
      end
    end

    it 'should to formatted fields by separator' do
      EverypayV4Wrapper.configure do |config|
        config.separator_flag = true
        config.separator_symbol = '_'
      end

      params = {
        transaction_amount: '2000',
        custom_field_1: 'this is description ',
        invoice_number: '122',
        linkpay_token: LINKPAY_TOKEN,
        order_reference: '233',
        customer_name: 'oleg  hasjanov  ',
        customer_email: 'oleg.phenomenon@gmail.com'
      }

      @link = described_class.new(key: KEY, params: params)
      expect(@link.build_link).to include('custom_field_1=this_is_description')
      expect(@link.build_link).to include('customer_name=oleg_hasjanov')

      EverypayV4Wrapper.configure do |config|
        config.separator_flag = nil
      end
    end
  end

  describe 'different case' do
    it 'by config should be set flag true for separator and money tansform, other by default' do
      EverypayV4Wrapper.configure do |config|
        config.currency_translation_flag = true
        config.separator_flag = true
      end

      params = {
        transaction_amount: '2000',
        custom_field_1: 'this is description ',
        invoice_number: '122',
        linkpay_token: LINKPAY_TOKEN,
        order_reference: '233',
        customer_name: 'oleg  hasjanov  ',
        customer_email: 'oleg.phenomenon@gmail.com'
      }

      @link = described_class.new(key: KEY, params: params)
      expect(@link.build_link).to include('custom_field_1=this_is_description')
      expect(@link.build_link).to include('customer_name=oleg_hasjanov')
      expect(@link.build_link).to include('transaction_amount=20.00')

      EverypayV4Wrapper.configure do |config|
        config.currency_translation_flag = false
        config.separator_flag = false
      end
    end

    it 'by config only separator flag is true, other by default' do
      EverypayV4Wrapper.configure do |config|
        config.separator_flag = true
      end

      params = {
        transaction_amount: '2000',
        custom_field_1: 'this is description ',
        invoice_number: '122',
        linkpay_token: LINKPAY_TOKEN,
        order_reference: '233',
        customer_name: 'oleg  hasjanov  ',
        customer_email: 'oleg.phenomenon@gmail.com'
      }

      @link = described_class.new(key: KEY, params: params)
      expect(@link.build_link).to include('custom_field_1=this_is_description')
      expect(@link.build_link).to include('customer_name=oleg_hasjanov')
      expect(@link.build_link).to include('transaction_amount=2000')

      EverypayV4Wrapper.configure do |config|
        config.separator_flag = false
      end
    end

    it 'possible to override default params with directon params in method' do
      EverypayV4Wrapper.configure do |config|
        config.separator_flag = true
        config.currency_translation_flag = true
      end

      params = {
        transaction_amount: '2000',
        custom_field_1: 'this is description ',
        invoice_number: '122',
        linkpay_token: LINKPAY_TOKEN,
        order_reference: '233',
        customer_name: 'oleg  hasjanov  ',
        customer_email: 'oleg.phenomenon@gmail.com'
      }

      @link = described_class.new(key: KEY, params: params, currency_translation: { flag: false })
      expect(@link.build_link).to include('custom_field_1=this_is_description')
      expect(@link.build_link).to include('customer_name=oleg_hasjanov')
      expect(@link.build_link).to include('transaction_amount=2000')

      EverypayV4Wrapper.configure do |config|
        config.separator_flag = false
        config.currency_translation_flag = false
      end
    end
  end
end