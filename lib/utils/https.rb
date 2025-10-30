
require 'json'

class HTTPS

  def self.http_request_call_post(url, json_request_payload, headers)
   response_payload = HTTParty.post(
      url,
      body: json_request_payload,
      headers: headers
    )
  end

end

