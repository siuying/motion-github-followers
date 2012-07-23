class FollowerController < UITableViewController
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

    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.reload
  end

  def reload
    if login
      self.title = "#{login}'s Followers"
      load_user(login)
    else
      self.title = "My Followers"
      load_current_user
    end
  end

  # UITableViewDataSource

  def  tableView(table, numberOfRowsInSection:section)
    self.followers.size
  end

  def tableView(table, cellForRowAtIndexPath:index_path)
    @reuse_identifier ||= "Follower"
    @place_holder ||= UIImage.imageNamed("avatar_placeholder.png")

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) 
    cell ||=  UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:@reuse_identifier)

    user  = user_by_index_path(index_path)
    cell.textLabel.text = user.login
    cell.imageView.setImageWithURL(NSURL.URLWithString(user.avatar_url), placeholderImage:@place_holder)

    cell
  end

  # UITableViewDelegate

  def tableView(table, didSelectRowAtIndexPath:index_path)
    table.deselectRowAtIndexPath(index_path, animated:true)
    user  = user_by_index_path(index_path)
    App.delegate.router.open("followers/#{user.login}")
  end

  private
  def user_by_index_path(index_path)
    index = index_path.indexAtPosition(1)
    self.followers[index]
  end

  def load_current_user
    puts "load current user"
    self.navigationController.navigationBar.topItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithTitle("Logout", style:UIBarButtonItemStylePlain, target:self, action:'logout')

    @success = lambda do |user_data|
      self.user = User.new(user_data)
      puts "user loaded: #{self.user}"
      load_user(self.user.login)
    end

    @failure = lambda do |error, code|
      App.alert("Failed loading user: #{error} (#{code})")
    end

    App.delegate.github.user(@success, @failure)
  end

  def load_user(user_login)
    puts "load user: #{user_login}"
    @success = lambda do |followers_data|
      puts "loaded followers: #{followers_data}"
      self.followers = followers_data.collect {|f| User.new(f) }
        .sort_by {|f| f.login.downcase }

      self.tableView.reloadData
    end

    @failure = lambda do |error, code|
      App.alert("Failed loading followers: #{error} (#{code})")
    end

    App.delegate.github.followers(user_login, @success, @failure)
  end

  def logout
    puts "logout"
    Settings.token = nil
    App.delegate.github.token = nil

    App.delegate.router.pop(false)
    App.delegate.router.open("login")
  end
end