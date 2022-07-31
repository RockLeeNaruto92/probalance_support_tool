require "google_drive"



class GoogleDrive
  attr_accessor :session

  def initialize
    session = GoogleDrive::Session.from_config("config/google_drive_config.json")
  end

end

