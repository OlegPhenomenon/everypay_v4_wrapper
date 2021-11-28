# Everypay v4 Wrapper Gateway

This is a wrapper over the Everypay v4 api, which simplifies the use of this functionality.

# Version
0.1.0

# Installation

```ruby
gem 'everypay_v4_wrapper', github: 'OlegPhenomenon/everypay_v4_wrapper', branch: :master
```

And then execute:

    $ bundle install

You can play with the gem by writing the command:

`bin/console`

## Usage

In order to build a link, you need to specify parameters, declare an instance of an object and call a method to build a link.

```ruby
require 'everypay_v4_wrapper'

params = {
  transaction_amount: '100.00',
  custom_field_1: 'this_is_description',
  invoice_number: '122',
  linkpay_token: LINKPAY_TOKEN,
  order_reference: '233',
  customer_name: 'oleg hasjanov',
  customer_email: 'oleg.phenomenon@gmail.com'
}

linker = EverypayV4Wrapper::LinkBuilder.new(params: params, key: KEY)
linker.build_link
```

result should be like this:
`"https://igw-demo.every-pay.com/lp?custom_field_1=this_is_description&customer_email=oleg.phenomenon@gmail.com&customer_name=oleg_hasjanov&invoice_number=122&linkpay_token=some-token&order_reference=233&transaction_amount=100.00&hmac=some-hmac"
`

### Params
The parameters depend on which fields you intend to use in the payment. All fields that you plan to use are configured in the Everypay demo environment https://mwt-demo.every-pay.com

Important notes !:
- LINKPAY_TOKEN must be specified in the parameters. When setting up links in the Everypay environment, this field will be called `Link token`
- You can also find KEY in the main settings of your account. This value is in the Api Secret field
- Some parameters require the separator to be underscore
- The amount of money must also be in the form of `100.00`. But, it is possible by the gem to format the amount itself by specifying the `currency_translation parameters: {field_name: 'transaction_amount', flag: true}`


### Formatting the amount of money
You can format the amount of money yourself using the money gem, it will look something like this:

```ruby
  def money_translate(sum)
      money = Money.new(sum, 'EUR')
      money&.format(symbol: nil, thousands_separator: false, decimal_mark: '.')
  end

    params = {
      transaction_amount: money_translate(sum)
        ....
    }
```

Another way to let this gem be customized by specifying the necessary parameters in the initialization:

```ruby
    linker = EverypayV4Wrapper::LinkBuilder.new(
                                                params: params,
                                                currency_translation: 
                                                  { field_name: 'transaction_amount',
                                                    flag: true,
                                                    symbol: nil,
                                                    currency: 'EUR',
                                                    thousands_separator: false,
                                                    decimal_mark: ','},
                                                key: KEY)
```

**field_name** is the field to be converted
**flag** - this indicates that you need to convert (default is false)

the rest of the fields are standard fields in the [money](https://github.com/RubyMoney/money) gem. For everypay, you shouldn't change them, because there is a certain set of rules when forming a url request.

**An important point! Keep in mind that if you trust the gem to format the price itself, then you must indicate the price in cents, for example, if the amount is `1000`, it will be formatted to the amount of `10,00`**

### Override
By default, the values in the initializer look like this, you yourself can override them at your discretion:

```ruby
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
```

##Initializer

You can initialize data as follows:
```ruby
EverypayV4Wrapper.configure do |config|
  config.secret_key = "super-key"
end

EverypayV4Wrapper.configuration.secret_key
=> "super-key"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rspec spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/OlegPhenomenon/everypay_v4_wrapper.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).