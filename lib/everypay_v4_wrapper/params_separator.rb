require_relative './interfaces/params_separator_interface'

module EverypayV4Wrapper
  class ParamsSeparator
    include ParamsSeparatorInterface

    def self.start_separate(params:, symbol: '_')
      res = {}
      params.map do |k, v|
        res[k] = separate_parameters_by_symbol(value: v,symbol: symbol)
      end

      res
    end

    private

    def self.separate_parameters_by_symbol(value: ,symbol:)
      value.strip.tr_s(' ', symbol).downcase
    end
  end
end
