describe Github do
  before do
    @github = Github.new
    @username = ENV['GITHUB_USERNAME']
    @password = ENV['GITHUB_PASSWORD']

    # should have set env variable
    @username.should.not.be.nil
    @password.should.not.be.nil
  end

  it "should login to github" do
    login_status = 0
    success = lambda { |login|
      login_status = 1
    }
    failure = lambda { |error|
      login_status = 2
    }

    @github.login(@username, @password, success, failure)
    wait 5.0 do
      login_status.should.be == 1
    end
  end
end