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
  end

  def load_user
    puts "load user"
    # success = lambda do |followers_data|
    # end

    # failure = lambda do |err_msg, code|
    # end

    # App.delegate.github.followers(login, success, failure)
  end

  def logout
    puts "logout"
    Settings.token = nil

    App.delegate.router.pop(false)
    App.delegate.router.open("login")
  end
end