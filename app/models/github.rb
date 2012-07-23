class Github
  attr_accessor :base_url, :token

  def initialize
    @base_url = "https://api.github.com"
  end

  def login(username, password, success, failure)
    url = request_url("/authorizations")
    payload = { 
      scopes: ["public_repo"], 
      note: "rubymotion github client"
    }
    headers = {
      Authorization: "BASIC " + base64(username + ":" + password)
    }
    options = {
      payload: BubbleWrap::JSON.generate(payload), 
      headers: headers,
      format: :json
    }
    BubbleWrap::HTTP.post(url, options) do |resp|
      if resp.ok?
        json = BubbleWrap::JSON.parse(resp.body.to_str)
        success.call(json)
      else
        failure.call(resp.error_message)
      end
    end
  end

  def request_url(method)
    "#{@base_url}#{method}"
  end

  private
  def base64(string)
    [string].pack("m")
  end
end