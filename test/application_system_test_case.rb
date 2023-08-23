require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  Webdrivers::Chromedriver.required_version = "114.0.5735.90"
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]
end
