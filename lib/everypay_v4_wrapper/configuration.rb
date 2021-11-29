module EverypayV4Wrapper
  class Configuration
    attr_accessor :secret_key
    attr_accessor :currency_translation_flag, :currency_translation_field, :currency_translation_symbol,
                  :currency_translation_thousands_separator, :currency_translation_currency, :currency_translation_decimal_mark
    attr_accessor :separator_flag, :separator_symbol, :separator_only, :separator_exception
  end
end
