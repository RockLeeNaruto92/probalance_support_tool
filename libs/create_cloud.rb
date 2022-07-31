require "yaml"

class CreateCloud
  @@config = nil

  class << self
    def login driver
      driver.get("#{config["base_url"]}/signin")
      email_input_field = driver.find_elements(:css, "#user_email").first
      password_input_field = driver.find_elements(:css, "#user_password").first
      
      raise new Exception("Not found email input field or password input field") if email_input_field == nil || password_input_field == nil

      login_btn = driver.find_elements(:css, ".btn.btn-primary.sign-in-btn").first

      email_input_field.send_keys config["account"]["email"]
      password_input_field.send_keys config["account"]["password"]
    end

    def config
      YAML.load(File.read "config/create_cloud.yaml")
    end
  end
end