require "addressable/uri"
require 'openssl'

require_relative './interfaces/link_builder_interface'
require_relative './money_transfer'

module EverypayV4Wrapper
  class LinkBuilder
    include LinkBuilderInterface

    attr_reader :params, :key, :everypay_url, :uri, :currency_translation

    def initialize(
                   key: EverypayV4Wrapper.configuration.key,
                   everypay_url: 'https://igw-demo.every-pay.com/lp',
                   currency_translation: {
                     field_name: 'transaction_amount',
                     flag: false,
                     symbol: nil,
                     currency: 'EUR',
                     thousands_separator: false,
                     decimal_mark: '.'
                   },
                   params:)

      @params = params
      @key = key

      @currency_translation_flag = currency_translation[:flag]
      @currency_translation_field = currency_translation[:field_name].to_sym
      @currency_translation_symbol = currency_translation[:symbol]
      @currency_translation_thousands_separator = currency_translation[:thousands_separator]
      @currency_translation_currency = currency_translation[:currency]
      @currency_translation_decimal_mark = currency_translation[:decimal_mark]

      @everypay_url = everypay_url

      @uri = Addressable::URI.new
    end

    def build_link
          data = CGI.unescape(parse_params)
          hmac = OpenSSL::HMAC.hexdigest('sha256', @key, data)

          "#{@everypay_url}?#{CGI.unescape(data)}&hmac=#{hmac}"
    end

    private

    def transfer_money
      return unless @params[@currency_translation_field]

      price = EverypayV4Wrapper::MoneyTransfer.new(@params[@currency_translation_field])
      price.transfer_it(currency: @currency_translation_currency,
                        symbol: @currency_translation_symbol,
                        thousands_separator: @currency_translation_thousands_separator,
                        decimal_mark: @currency_translation_decimal_mark)
    end

    def parse_params
      user_params = @params.clone
      if @currency_translation_flag && !user_params[@currency_translation_field].nil?
        user_params[@currency_translation_field] = transfer_money
      end

      @uri.query_values = user_params
      @uri.query
    end
  end
end
