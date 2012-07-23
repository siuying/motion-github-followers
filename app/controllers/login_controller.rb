class LoginController < Formotion::FormController
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
      self.login(form.render)
    end
    self
  end

  def login(data)
  end

end