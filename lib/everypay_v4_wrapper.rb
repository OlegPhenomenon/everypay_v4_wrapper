require 'everypay_v4_wrapper/link_builder'
require 'everypay_v4_wrapper/version'
require 'everypay_v4_wrapper/configuration'

module EverypayV4Wrapper
  class Error < StandardError; end
  class NotAvailableError < Error; end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure(&block)
      yield(configuration)
    end

    def output_config_data
      p "THis is your key: #{EverypayV4Wrapper.configuration.secret_key}"
    end
  end
end
