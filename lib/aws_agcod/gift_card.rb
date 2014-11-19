module AwsAgcod
  class GiftCard

    attr_reader :credentials

    def initialize(credentials)
      @credentials = credentials
    end

    # Create a gift card
    # @param [String] country
    # @param [String] request_id
    # @param [Float] amount
    # @return The informations of a complete Amazon gift card
    def create(request_id, amount)
      action = 'CreateGiftCard'
      parameters = {
          'creationRequestId' => "#{credentials.partner_id}#{request_id}",
          'value' => {
              'currencyCode' => credentials.currency_code,
              'amount' => amount
          }
      }
      response = AwsAgcod.post_http_request(credentials, action, parameters, request_id)
      test = AwsAgcod.format_response(response)
      puts "\n Test: #{test}"
      test
    end

    # Cancel a gift card
    # This action can be done as long as the user has not claimed the gift card
    # @param [String] request_id
    # @param [String] gift_card_id
    # @return The state of the action and main informations of the gift card canceled
    def cancel(request_id, gift_card_id)
      action = 'CancelGiftCard'
      parameters = {
          'creationRequestId' => "#{credentials.partner_id}#{request_id}",
          'gcId' => gift_card_id
      }
      response = AwsAgcod.post_http_request(credentials, action, parameters, request_id)
      AwsAgcod.format_response(response)
    end
  end
end