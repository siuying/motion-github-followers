class User
  attr_reader :id, :login, :url, :avatar_url

  def initialize(params={})
    @id     = params[:id]
    @login  = params[:login]
    @url    = params[:url]
    @avatar_url = params[:avatar_url]
  end

  def to_s
    "<User##{login}>"
  end
end