module LinkBuilderInterface
  def build_link
    raise NotImplementedError, 'Not implemented'
  end

  def transfer_money
    raise NotImplementedError, 'Not implemented'
  end

  def parse_params
    raise NotImplementedError, 'Not implemented'
  end

  def currency_translation_flag
    raise NotImplementedError, 'Not implemented'
  end

  def currency_translation_field
    raise NotImplementedError, 'Not implemented'
  end

  def currency_translation_symbol
    raise NotImplementedError, 'Not implemented'
  end

  def currency_translation_thousands_separator
    raise NotImplementedError, 'Not implemented'
  end

  def currency_translation_currency
    raise NotImplementedError, 'Not implemented'
  end

  def currency_translation_decimal_mark
    raise NotImplementedError, 'Not implemented'
  end

  def separator_flag
    raise NotImplementedError, 'Not implemented'
  end

  def separator_symbol
    raise NotImplementedError, 'Not implemented'
  end

  def separator_only
    raise NotImplementedError, 'Not implemented'
  end

  def separator_exception
    raise NotImplementedError, 'Not implemented'
  end
end
