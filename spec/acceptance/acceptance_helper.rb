require 'rails_helper'

RSpec.configure do |config|
  # Capybara.javascript_driver = :webkit
  Capybara.ignore_hidden_elements = false

  config.include AcceptanceHelpers, type: :feature

  Capybara.server = :puma



  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new(app, browser: :chrome)
  end

  Capybara.register_driver :headless_chrome do |app|
    caps = Selenium::WebDriver::Remote::Capabilities.chrome(loggingPrefs: { browser: 'ALL' })
    opts = Selenium::WebDriver::Chrome::Options.new

    chrome_args = %w[--headless --window-size=1920,1080 --no-sandbox --disable-dev-shm-usage]
    chrome_args.each { |arg| opts.add_argument(arg) }
    Capybara::Selenium::Driver.new(app, browser: :chrome, options: opts, desired_capabilities: caps)
  end


  Capybara.configure do |config|
    # change this to :chrome to observe tests in a real browser
    config.javascript_driver = :headless_chrome
  end
end
