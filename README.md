# AwsAgcod

Amazon Gift Codes On Demand (AGCOD) is a set of systems provided by Amazon and designed to allow partners and third party developers
to create and distribute Amazon gift codes in real-time, on demand.

It uses the following gem to sign requests : https://github.com/ifeelgoods/aws4
It is forked from https://github.com/cmdrkeene/aws4

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'aws_agcod'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install aws_agcod

## Usage

```bash
# Authenticate on AGCOD service
config = {access_key: 'random_access_key',
     secret_key: 'random_secret_key',
     partner_id: 'partner_id',
     country: 'FR',
     region: 'eu-west-1',
    host_url: 'https://agcod-v2-eu-gamma.amazon.com'}
authentication = AwsAgcod::AuthenticationCredentials.new(config)
# Generate a new code
request_id = 'your_request_id'
amount = 5 # 5 €
AwsAgcod::GiftCard.new(authentication).create(request_id, amount)
```

## Contributing

1. Fork it ( https://github.com/begault/aws_agcod/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Licence

The MIT License (MIT)

Copyright (c) 2014 Agathe Begault

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
