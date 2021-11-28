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
end
