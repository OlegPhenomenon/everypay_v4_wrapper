require 'money'
require "addressable/uri"
require 'openssl'

require_relative './interfaces/link_builder_interface'

module EverypayV4Wrapper
  class LinkBuilder
    include LinkBuilderInterface

    attr_reader :params, :key, :everypay_url, :uri

    def initialize(params:,
                   key: EverypayV4Wrapper.configuration.key,
                   everypay_url: 'https://igw-demo.every-pay.com/lp')

      @params = params
      @key = key
      @everypay_url = everypay_url

      @uri = Addressable::URI.new
    end

    def build_link
          data = CGI.unescape(parse_params)
          hmac = OpenSSL::HMAC.hexdigest('sha256', @key, data)

          "#{@everypay_url}?#{CGI.unescape(data)}&hmac=#{hmac}"
    end

    private

    def parse_params
      @uri.query_values = @params
      @uri.query
    end
  end
end
