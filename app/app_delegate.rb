class AppDelegate
  attr_reader :form_controller

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    return true if RUBYMOTION_ENV == 'test'

    @form_controller = LoginController.alloc.init
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = @form_controller
    @window.makeKeyAndVisible
    true
  end
end
