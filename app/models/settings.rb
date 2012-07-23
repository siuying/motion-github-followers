module Settings
  module_function

  def token
    App::Persistence["token"]
  end
  
  def token=(token)
    App::Persistence["token"] = token
  end

  def logged_in?
    !App::Persistence["token"].nil?
  end

end