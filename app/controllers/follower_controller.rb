class FollowerController < UIViewController
  attr_accessor :login
  attr_accessor :followers, :user

  def initWithParams(params = {})
    init()
    self.login = params[:login]
    self.followers = []
    self
  end

  def loadView
    super

    self.title = "Followers"
    if login
      load_user(login)
    else
      load_current_user
    end
  end

  private
  def load_current_user
    puts "load current user"
    self.navigationController.navigationBar.topItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithTitle("Logout", style:UIBarButtonItemStylePlain, target:self, action:'logout')

    success = lambda do |user_data|
      self.user = User.new(user_data)
      puts "user loaded: #{self.user}"
      load_user(self.user.login)
    end

    failure = lambda do |error, code|
      App.alert("Failed loading user: #{error} (#{code})")
    end

    App.delegate.github.user(success, failure)
  end

  def load_user(user_login)
    puts "load user: #{user_login}"
    success = lambda do |followers_data|
      puts "loaded followers: #{followers_data}"
    end

    failure = lambda do |error, code|
      App.alert("Failed loading followers: #{error} (#{code})")
    end

    App.delegate.github.followers(user_login, success, failure)
  end

  def logout
    puts "logout"
    Settings.token = nil

    App.delegate.router.pop(false)
    App.delegate.router.open("login")
  end
end