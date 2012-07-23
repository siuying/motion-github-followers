describe Github do
  before do
    @github = Github.new
    @username = ENV['GITHUB_USERNAME']
    @password = ENV['GITHUB_PASSWORD']
    @token    = ENV['GITHUB_TOKEN']

    # should have set env variable
    @username.should.not.be.nil
    @password.should.not.be.nil
    @token.should.not.be.nil
  end

  it "should login to github" do
    login_status = 0
    success = lambda { |login|
      login_status = 1
      puts login[:token]
    }
    failure = lambda { |error, status_code|
      login_status = 2
    }

    @github.login(@username, @password, success, failure)
    wait 3.0 do
      login_status.should.be == 1
    end
  end

  it "should return user profile" do 
    @user = nil
    success = lambda { |data|
      @user = User.new(data)
      @user.id.should.not.be.nil
      @user.login.should.not.be.nil
      @user.url.should.not.be.nil
      @user.avatar_url.should.not.be.nil
    }
    failure = lambda { |error, status_code|
      @user = nil
    }

    @github.token = @token
    @github.user(success, failure)
    wait 3.0 do
      @user.should.not.be.nil
    end
  end

  it "should return followers of user" do
    @followers = nil
    success = lambda { |data|
      @followers = data
      @followers.is_a?(Array).should.be == true
      @followers.size.should.be > 0
    }
    failure = lambda { |error, status_code|
      @followers = nil
    }

    @github.token = @token
    @github.followers("ignitiontester", success, failure)
    wait 3.0 do
      @followers.should.not.be.nil
    end
  end
end