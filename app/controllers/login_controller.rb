class LoginController < Formotion::FormController
  attr_accessor :validator

  def init
    form = Formotion::Form.new({
      sections: [
        {
          title: "GitHub Login",
          rows: [
            {
              title: "Username",
              key: :username,
              placeholder: "Username",
              type: :string,
              autocorrection: :no,
              auto_capitalization: :none
            },
            {
              title: "Password",
              key: :password,
              placeholder: "Password",
              type: :string,
              secure: true,
              autocorrection: :no,
              auto_capitalization: :none
            }
          ]
        },
        {
          rows: [
            {
              title: "Login",
              type: :submit
            }
          ]
        }
      ]
    })
    self.initWithForm(form)
    self.form.on_submit do |form|
      data = form.render
      if validator.valid?(data)
        login(data[:username], data[:password])

      else
        puts "validation error: #{validator.error_message}"
        App.alert "Cannot Login\n#{validator.error_message}"

      end
    end
    self.validator = LoginValidator.new
    self
  end

  def login(username, password)
    login_failed = lambda do |error, code|
      App.alert "Login Failed: #{error}"
    end

    login_succeed = lambda do |auth|
      if auth[:token]
        Settings.token = auth[:token]

        App.delegate.router.pop(false)
        App.delegate.router.open("followers")
      else
        login_failed.call("Token not available")
      end
    end

    App.delegate.github.login(username, password, login_succeed, login_failed)
  end

end