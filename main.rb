require "./libs/create_cloud"
require "./libs/message_generator"
require "./libs/google_drive_initor"
require "selenium-webdriver"

def process_for_work_sheet work_sheet, driver
  work_sheet.rows.each_with_index do |row, index|
    next if index < 2
    process_for_1_row work_sheet, row, index + 1, driver
  end
end

def process_for_1_row work_sheet, row, row_index, driver
  project_id = row['B'.ord - 'A'.ord]
  task_id = row['C'.ord - 'A'.ord]
  ticket_id = row['D'.ord - 'A'.ord]
  ticket_title = row['E'.ord - 'A'.ord]
  action = row['G'.ord - 'A'.ord].to_sym
  action_status = row['H'.ord - 'A'.ord]
  to_members_name = row['I'.ord - 'A'.ord].split("\n")
  estimate_hours = row['K'.ord - 'A'.ord]
  pr_expect_creation_date = row['L'.ord - 'A'.ord]
  late_reason = row['M'.ord - 'A'.ord]
  new_expect_pr_creation_date = row['N'.ord - 'A'.ord]
  new_estimation_hours = row['O'.ord - 'A'.ord]

  puts "Start for ticket #{ticket_id}: #{ticket_title}"

  message = case action.to_sym
  when :late_ticket
    MessageGenerator.generate(:late_ticket, {
      member_names: to_members_name.map{|n| n + "さん"}.join(","),
      late_reason: late_reason,
      new_expect_pr_creation_date: new_estimation_hours
    })
  when :send_estimation
    MessageGenerator.generate(:send_estimation, {
      member_names: to_members_name.map{|n| n + "さん"}.join(","),
      est_time: estimate_hours,
      pr_expect_creation_date: pr_expect_creation_date
    })
  else
    nil
  end

  if confirm_send_message ticket_id, ticket_title, message, action_status
    CreateCloud.send_message_to_ticket driver, message, project_id,
      task_id, ticket_id, to_members_name
    work_sheet[row_index + 1, 'H'.ord - 'A'.ord + 1] = "DONE"
    work_sheet.save
  end
end

def confirm_send_message ticket_id, ticket_title, message, action_status
  puts "#{ticket_id}: #{ticket_title}"
  puts "-----------------------\n\n#{message}\n\n-----------------------\n\n"

  if action_status == "DONE"
    puts "Already sent to message to create cloud, do you want to send it again? (y/n)"
  else
    puts "Are you sure to send above message? (y/n)"
  end

  input = $stdin.gets.chomp

  while true
    if input == "y" || input == "n" || input == "Y" || input == "N"
      break
    end
    input = $stdin.gets.chomp
  end

  input == "Y" || input == "y"
end

work_sheets = GoogleDriveInitor.work_sheets

Selenium::WebDriver.logger.output = File.join("./tmp", "selenium.log")
Selenium::WebDriver.logger.level = :warn
driver = Selenium::WebDriver.for :chrome
CreateCloud.login driver

process_for_work_sheet work_sheets[1], driver

driver.quit