require 'yaml'

module AwsAgcod
  class AuthenticationCredentials

    attr_reader :access_key, :secret_key, :region, :country, :partner_id, :host_url

    CURRENCIES = YAML.load_file(File.join(File.dirname(__FILE__),'../../config/currencies.yml'))

      def initialize(config)
      @access_key = config[:access_key] || config["access_key"]
      @secret_key = config[:secret_key] || config["secret_key"]
      @partner_id = config[:partner_id] || config["partner_id"]
      @country = config[:country] || config["country"]
      @region = config[:region] || config["region"]
      @host_url = config[:host_url] || config['host_url']
    end

    def currency_code
      puts "\n CURRENCIES: #{CURRENCIES}"
      CURRENCIES[@country]
    end
  end
end
