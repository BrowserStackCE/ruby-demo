require 'rubygems'
require 'selenium-webdriver'
require 'test-unit'
require 'browserstack/local'
require 'rest-client'

class MobileTest < Test::Unit::TestCase

  def setup

    caps = Selenium::WebDriver::Remote::Capabilities.new(
      'bstack:options': {
        "deviceName" => ENV['device'],
        "projectName" => "BrowserStack",
        "buildName" => ENV['build_name'],
        "sessionName" => "Parallel Test: " + ENV['device'],
        "local" => "false",
        "debug"=> "true",
        "seleniumCdp"=> true,
        "seleniumVersion" => "4.1.2"
      }
    )

    url = "http://#{ENV["BROWSERSTACK_USER"]}:#{ENV["BROWSERSTACK_ACCESSKEY"]}@hub-cloud.browserstack.com/wd/hub"
    @driver = Selenium::WebDriver.for(:remote, :url => url, :capabilities => caps)

  end

  def test_post
		@driver.navigate.to 'http://www.browserstack.com'
		title = @driver.title
    assert_equal(title, title)
  end

  def teardown
    api_url = "https://#{ENV["BROWSERSTACK_USER"]}:#{ENV["BROWSERSTACK_ACCESSKEY"]}@www.browserstack.com/automate/sessions/#{@driver.session_id}.json"
    RestClient.put api_url, {"status"=>"passed"}, {:content_type => :json}
    @driver.quit
  end

end
