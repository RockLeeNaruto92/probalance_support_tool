require "yaml"
require "pry"
class CreateCloud
  @@config = nil
  TICKET_SEARCH_PATTERN = ":base_url/projects/:project_id/tasks/:task_id/log_work?items_each_page=&q%5Bid_or_received_order_company_name_or_ordered_company_name_or_user_name_or_description_cont%5D=:ticket_id&q%5Bperson_in_charge_id_eq%5D=&q%5Bcreated_at_gteq%5D=&q%5Bcreated_at_lteq%5D=&q%5Bdelivery_date_gteq%5D=&q%5Bdelivery_date_lteq%5D=&q%5Bexpiration_date_gteq%5D=&q%5Bexpiration_date_lteq%5D=&q%5Bunit_eq%5D="

  class << self
    def login driver
      driver.get("#{config["base_url"]}/signin")
      email_input_field = driver.find_elements(:css, "#user_email").first
      password_input_field = driver.find_elements(:css, "#user_password").first
      
      raise new Exception("Not found email input field or password input field") if email_input_field == nil || password_input_field == nil

      login_btn = driver.find_elements(:css, ".btn.btn-primary.sign-in-btn").first

      email_input_field.send_keys config["account"]["email"]
      password_input_field.send_keys config["account"]["password"]
      login_btn.click
    end

    def send_message_to_ticket driver, message, project_id, task_id, ticket_id, to_members_name = ["山田"]
      # ticket_search_url = TICKET_SEARCH_PATTERN.gsub(":base_url", config["base_url"])
      #   .gsub(":project_id", project_id.to_s)
      #   .gsub(":task_id", task_id.to_s)
      #   .gsub(":ticket_id", ticket_id.to_s)

      ticket_search_url = "https://membernew.createcloud.jp/projects/1716/2025/ticket"
      driver.get ticket_search_url

      chat_icon = driver.find_elements(:css, "#js_chat_ticket_#{ticket_id}").first
      chat_icon.click

      sleep 5

      to_btn = driver.find_elements(:css, ".chat-outer.show .btn.btn-primary.send-to").first
      to_btn.click
      sleep 1

      search_member_input_field = driver.find_elements(:css, ".chat-outer.show .form-control.js-search-user").first

      to_members_name.each do |name|
        search_member_input_field.send_keys name
        member = driver.find_elements(:css, ".chat-outer.show .chat-users__container--detail.js-chat-user").detect do |m|
          m.attribute("class").index("d-none") == nil
        end
        member.click if member
        search_member_input_field.clear
        sleep 1
      end

      ok_btn = driver.find_elements(:css, ".chat-outer.show .chat-users__container .chat-users__button a.btn").first
      ok_btn.click
      sleep 1
      
      msg_content = driver.find_elements(:css, ".chat-outer.show #message_content").first
      msg_content.send_keys message
      sleep 1

      send_btn = driver.find_elements(:css, ".chat-outer.show .btn.btn-primary.send-message").first
      send_btn.click
      sleep 1
    end

    def config
      YAML.load(File.read "config/create_cloud.yaml")
    end
  end
end