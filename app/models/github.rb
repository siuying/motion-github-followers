class Github
  attr_accessor :base_url, :token

  def initialize
    @base_url = "https://api.github.com"
  end

  def login(username, password, success, failure)
    payload = { 
      scopes: ["public_repo"], 
      note: "rubymotion github client"
    }
    headers = {
      Authorization: "BASIC " + base64(username + ":" + password)
    }
    options = {
      payload: BubbleWrap::JSON.generate(payload), 
      headers: headers
    }
    api_request(:post, '/authorizations', options, success, failure, false)
  end

  def user(success, failure)
    api_request(:get, '/user', {}, success, failure)
  end
  
  def followers(user, success, failure)
    api_request(:get, "/users/#{user}/followers", {}, success, failure)
  end

  private
  def api_request(http_method, method, options, success, failure, use_token=true)
    url = request_url(method, use_token)
    options = {format: :json}.merge(options)

    puts "api_request: #{url}, #{options}"
    BubbleWrap::HTTP.send(http_method, url, options) do |resp|
      if resp.ok?
        json = BubbleWrap::JSON.parse(resp.body.to_str)
        success.call(json)

      else
        if resp.error_message
          failure.call(resp.error_message, resp.status_code)

        elsif resp.headers["Status"]
          status = resp.headers["Status"]
          failure.call(status, resp.status_code)

        else
          failure.call("Unknown error", resp.status_code)

        end

      end
    end
  end

  def request_url(method, use_token=true)
    if use_token && token
      "#{@base_url}#{method}?access_token=#{token}"
    else
      "#{@base_url}#{method}"
    end
  end

  def base64(string)
    [string].pack("m")
  end
end