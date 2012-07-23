class AppDelegate
  attr_reader :form_controller
  attr_reader :github

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    setup_github
    return true if RUBYMOTION_ENV == 'test'

    setup_window
    true
  end

  private
  def setup_github
    @github = Github.new
  end

  def setup_window
    @form_controller = LoginController.alloc.init
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = @form_controller
    @window.makeKeyAndVisible    
  end

end
