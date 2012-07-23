class FollowerController < UIViewController
  attr_accessor :login
  attr_accessor :followers

  def initWithParams(params = {})
    init()
    self.login = params[:login]
    self.followers = []
    self
  end

  def loadView
    super

    self.title = "Followers"
    load_user(login)
  end

  private
  def load_user
    puts "load user"
    # success = lambda do |followers_data|
    # end

    # failure = lambda do |err_msg, code|
    # end

    # App.delegate.github.followers(login, success, failure)
  end

end