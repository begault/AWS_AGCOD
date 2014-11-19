require "aws_agcod/version"
require 'json'
require 'aws4'
require 'logger'
require 'httpclient'

module AwsAgcod

  # Check the AGCOD Service status as wellas the connectivity to the host to the endpoint
  # @return State of connection and message
  def health_check
    action = 'sping'
    uri = AwsAgcod.uri(action, @credentials.country)

    Rails.logger.info("***\r\n: Amazon AGCOD REQUEST / GET: \n Uri: #{uri} \r\n")
    response = HTTPClient.new.get uri.to_s
    Rails.logger.info("***\r\n: Amazon AGCOD RESPONSE / GET: #{response.code} / #{response.body}\r\n")

    return  {code: response.code, resp: response.body}
  end

  def self.request_body(action, request_id, partner_id, parameters)
    body = {
        'partnerId' => partner_id
    }.merge(parameters).to_json
  end

  def self.uri(action, host_url)
    URI("#{host_url}/#{action}")
  end

  def self.headers_to_sign(action, uri)
    now = Time.now.utc
    {
        'content-type' => 'application/json',
        'x-amz-date' => now.strftime("%Y%m%dT%H%M%SZ"),
        'accept' => 'application/json',
        'host' => uri.host,
        'x-amz-target' => "com.amazonaws.agcod.AGCODService.#{action}",
        'date' => now.to_s
    }
  end

  def self.signed_headers(credentials, method, action, uri, body)
    #binding.pry
    config = {
        "access_key" => credentials.access_key,
        "secret_key" => credentials.secret_key,
        "region" => credentials.region
    }

    signer = AWS4::Signer.new(config)
    headers = headers_to_sign(action, uri)
    signed_headers = signer.sign(method, uri, headers, body, true, 'AGCODService')

    headers.merge!(signed_headers)
  end

  def self.get_http_request(credentials, action, parameters)
    uri = uri(action, credentials.host_url)
    headers = signed_headers('GET', action, uri, nil, credentials.country)

    logger = Logger.new(STDOUT)
    logger.info("***\r\n: Amazon AGCOD REQUEST / GET: \n Uri: #{uri} \n Header: #{headers} \r\n")
    response = HTTPClient.new.get uri.to_s, header: headers
    logger.info("***\r\n: Amazon AGCOD RESPONSE / GET: #{response.code} / #{response.body}\r\n")

    return response
  end

  def self.post_http_request(credentials, action, parameters, request_id=nil)
    uri = uri(action, credentials.host_url)
    body = request_body(action, request_id, credentials.partner_id, parameters)
    headers = signed_headers(credentials, 'POST', action, uri, body)

    logger = Logger.new(STDOUT)
    logger.info("***\r\n: Amazon AGCOD REQUEST / POST: \n Uri: #{uri} \n Headers: #{headers} \n Body: #{body} \r\n")
    response = HTTPClient.new.post uri, body, headers
    logger.info("***\r\n: Amazon AGCOD RESPONSE / POST: #{response.code} / #{response.body}\r\n")

    return response
  end

  def self.format_response(response)
    {code: response.code, resp: (response.body.empty? ? nil : JSON.parse(response.body))}
  end

end
