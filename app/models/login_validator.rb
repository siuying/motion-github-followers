class LoginValidator
  attr_accessor :errors

  def initialize
    @errors = []
  end

  def valid?(data)
    @errors = []

    if data[:username].nil? || data[:username].strip == ""
      @errors << "Username cannot be empty"
    end
    
    if data[:password].nil? || data[:password].strip == ""
      @errors << "Password cannot be empty"
    end

    !has_errors?
  end

  def has_errors?
    @errors.size > 0
  end

  def error_message
    if has_errors?
      @errors.join("\n")
    else
      ""
    end
  end
end