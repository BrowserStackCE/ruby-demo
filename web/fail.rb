require 'rubygems'
require 'selenium-webdriver'
require 'test-unit'
require 'browserstack/local'
require 'rest-client'

class FailTest < Test::Unit::TestCase

  def setup
    caps = Selenium::WebDriver::Remote::Capabilities.new(
      'bstack:options': {
        "os" => "Windows",
        "osVersion" => "10",
        "projectName" => "BrowserStack",
        "buildName" => "Demo Example",
        "sessionName" => "Failed test",
        "local" => "false",
        "debug"=> "true",
        "seleniumCdp"=> true,
        "seleniumVersion" => "4.1.2"
      },
      browser_name: 'IE',
      browserVersion: '11.0'
    )

    url = "http://#{ENV["BROWSERSTACK_USER"]}:#{ENV["BROWSERSTACK_ACCESSKEY"]}@hub-cloud.browserstack.com/wd/hub"
    @driver = Selenium::WebDriver.for(:remote, :url => url, :capabilities => caps)

  end

  def test_post
		@driver.navigate.to 'http://www.google.com'
		title = @driver.title
    assert_equal("Incorrect Page Title", title)
  end

  def teardown
    api_url = "https://#{ENV["BROWSERSTACK_USER"]}:#{ENV["BROWSERSTACK_ACCESSKEY"]}@www.browserstack.com/automate/sessions/#{@driver.session_id}.json"
  	RestClient.put api_url, {"status"=>"failed", "reason"=>"Wrong title"}, {:content_type => :json}
    @driver.quit
  end

end
