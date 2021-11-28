require 'money'

require_relative './interfaces/money_transfer_interface'

module EverypayV4Wrapper
  class MoneyTransfer
    include MoneyTransferInterface

    attr_reader :sum

    def initialize(sum)
      @sum = sum.to_s
    end

    def transfer_it(currency: 'EUR', symbol: nil, thousands_separator: false, decimal_mark: '.')
      money = Money.new(@sum, currency)
      money&.format(symbol: symbol, thousands_separator: thousands_separator, decimal_mark: decimal_mark)
    end
  end
end
