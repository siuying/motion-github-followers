class AppDelegate
  attr_reader :form_controller
  attr_reader :github, :router

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    setup_github
    return true if RUBYMOTION_ENV == 'test'

    setup_urls

    if Settings.logged_in?
      @router.open("followers", false)
    else
      @router.open("login", false)
    end

    true
  end

  private
  def setup_github
    @github = Github.new
    @github.token = Settings.token
  end

  def setup_urls
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    @router = Routable::Router.router
    @router.navigation_controller = UINavigationController.alloc.init

    @router.map("login", LoginController, modal: true)
    @router.map("followers/:login", FollowerController)
    @router.map("followers", FollowerController)

    @window.rootViewController = @router.navigation_controller
    @window.makeKeyAndVisible
  end

end
