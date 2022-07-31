require "./libs/create_cloud"
require "selenium-webdriver"

driver = Selenium::WebDriver.for :chrome
CreateCloud.login driver

CreateCloud.send_message_to_ticket driver, "Testtestestestest\n testestestes\ntestestes\n", 1716, 2025, 4156, ["山田", "The Supplier"]
