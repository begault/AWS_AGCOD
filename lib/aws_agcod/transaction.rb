module AwsAgcod
  class Transaction

    attr_reader :credentials

    def initialize(credentials)
      @credentials = credentials
    end

    # Retrieve a list of transactions (up to 1,000 per call) for a given timeframe.
    # This method should not be called more than once per minute
    # (one off back-to-back retry requests due to a timeout for example, is ok).
    # This operation may be blocked on a per partner basis if
    # the above threshold is exceeded in a manner
    # (the system is flooded with excessive requests causes a Denial of Service)
    # which affects the availability of the system for other operation calls.
    # @param [DateTime] start_date Start date of range
    # @param [DateTime] end_date End date of range
    # @param [Integer] page_index page where the read begins
    # @param [Integer] page_size List of transaction per page
    # @param [Boolean] show_no_ops indicates whether the returned results would include idempotent operations
    # @return The whole transations list for a given timeframe
    def get_activity_page(request_id, start_date, end_date, page_index=0, page_size=200, show_no_ops=true)
      action = 'GetGiftCardActivityPage'
      parameters = {
          'requestId' => request_id,
          'utcStartDate' => start_date.strftime('%Y-%m-%dT%H:%M:%SZ'),
          'utcEndDate' => end_date.strftime('%Y-%m-%dT%H:%M:%SZ'),
          'pageIndex' => page_index,
          'pageSize' => page_size,
          'showNoOps' => show_no_ops
      }
      response = AwsAgcod.post_http_request(credentials, action, parameters)
      AwsAgcod.format_response(response)
    end
  end
end