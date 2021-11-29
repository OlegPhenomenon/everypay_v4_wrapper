require "addressable/uri"
require 'openssl'

require_relative './interfaces/link_builder_interface'
require_relative './money_transfer'

module EverypayV4Wrapper
  class LinkBuilder
    include LinkBuilderInterface

    attr_reader :params, :key, :everypay_url, :uri, :currency_translation, :separator

    def initialize(
                   key: EverypayV4Wrapper.configuration.secret_key,
                   everypay_url: 'https://igw-demo.every-pay.com/lp',
                   currency_translation: { },
                   #   {
                   #   field_name: 'transaction_amount',
                   #   flag: false,
                   #   symbol: nil,
                   #   currency: 'EUR',
                   #   thousands_separator: false,
                   #   decimal_mark: '.'
                   # },
                   separator: { },
                   #   {
                   #   flag: false,
                   #   symbol: '_',
                   #   only: [],
                   #   exception: [],
                   # },
                   params:)

      @params = params
      @key = key
      @currency_translation = currency_translation
      @separator = separator

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
      return unless @params[currency_translation_field]

      price = EverypayV4Wrapper::MoneyTransfer.new(@params[currency_translation_field])
      price.transfer_it(currency: currency_translation_currency,
                        symbol: currency_translation_symbol,
                        thousands_separator: currency_translation_thousands_separator,
                        decimal_mark: currency_translation_decimal_mark)
    end

    def parse_params
      user_params = @params.clone
      if currency_translation_flag && !user_params[currency_translation_field].nil?
        user_params[currency_translation_field] = transfer_money
      end


      user_params = EverypayV4Wrapper::ParamsSeparator.start_separate(params: user_params, symbol: separator_symbol) if separator_flag

      @uri.query_values = user_params
      @uri.query
    end

    def currency_translation_flag
      return false if EverypayV4Wrapper.configuration.currency_translation_flag.nil? && @currency_translation[:flag].nil?

      return EverypayV4Wrapper.configuration.currency_translation_flag if @currency_translation[:flag].nil?

      @currency_translation[:flag]
    end

    def currency_translation_field
      return :transaction_amount if EverypayV4Wrapper.configuration.currency_translation_field.nil? && @currency_translation[:field_name].nil?

      return EverypayV4Wrapper.configuration.currency_translation_field.to_sym if @currency_translation[:field_name].nil?

      @currency_translation[:field_name].to_sym
    end

    def currency_translation_symbol
      return nil if EverypayV4Wrapper.configuration.currency_translation_symbol.nil? && @currency_translation[:symbol].nil?

      return EverypayV4Wrapper.configuration.currency_translation_symbol if @currency_translation[:symbol].nil?

      @currency_translation[:symbol]
    end

    def currency_translation_thousands_separator
      return false if EverypayV4Wrapper.configuration.currency_translation_thousands_separator.nil? && @currency_translation[:thousands_separator].nil?

      return EverypayV4Wrapper.configuration.currency_translation_thousands_separator if @currency_translation[:thousands_separator].nil?

      @currency_translation[:thousands_separator]
    end

    def currency_translation_currency
      return 'EUR' if EverypayV4Wrapper.configuration.currency_translation_currency.nil? && @currency_translation[:currency].nil?

      return EverypayV4Wrapper.configuration.currency_translation_currency if @currency_translation[:currency].nil?

      @currency_translation[:currency]
    end

    def currency_translation_decimal_mark
      return '.' if EverypayV4Wrapper.configuration.currency_translation_decimal_mark.nil? && @currency_translation[:decimal_mark].nil?

      return EverypayV4Wrapper.configuration.currency_translation_decimal_mark if @currency_translation[:decimal_mark].nil?

      @currency_translation[:decimal_mark]
    end

    def separator_flag
      return false if EverypayV4Wrapper.configuration.separator_flag.nil? && @separator[:flag].nil?

      return EverypayV4Wrapper.configuration.separator_flag if @separator[:flag].nil?

      @separator[:flag]
    end

    def separator_symbol
      return '_' if EverypayV4Wrapper.configuration.separator_symbol.nil? && @separator[:symbol].nil?

      return EverypayV4Wrapper.configuration.separator_symbol if @separator[:symbol].nil?

      @separator[:symbol]
    end

    def separator_only
      return [] if EverypayV4Wrapper.configuration.separator_only.nil? && @separator[:only].nil?

      return EverypayV4Wrapper.configuration.separator_only if @separator[:only].nil?

      @separator[:only]
    end

    def separator_exception
      return [] if EverypayV4Wrapper.configuration.separator_exception.nil? && @separator[:exception].nil?

      return EverypayV4Wrapper.configuration.separator_exception if @separator[:exception].nil?

      @separator[:exception]
    end
  end
end
