require "google_drive"
require "yaml"

class GoogleDriveInitor
  class << self
    def work_sheets
      session = GoogleDrive::Session.from_config("config/google_drive_config.json")
      session.spreadsheet_by_key(sheet_config["sheet_key"]).worksheets
    end
  
    def sheet_config
      YAML.load(File.read "config/sheet_config.yaml")
    end
  end
end

