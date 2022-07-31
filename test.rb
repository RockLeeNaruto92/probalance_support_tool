require "./libs/create_cloud"
require "./libs/message_generator"
require "selenium-webdriver"

driver = Selenium::WebDriver.for :chrome
CreateCloud.login driver

message = MessageGenerator.generate(:late_ticket, {
  member_names: "山田",
  late_reason: "affected of another ticket",
  late_hours: "10",
  new_expect_pr_creation_date: "2022/07/31"
})

if message != nil
  CreateCloud.send_message_to_ticket driver, message, 1716, 2025, 4156, ["山田", "The Supplier"]
end

sleep 10

driver.quit