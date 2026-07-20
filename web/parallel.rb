require 'rubygems'
require 'selenium-webdriver'
require 'test-unit'
require 'browserstack/local'
require 'rest-client'

class ParallelTest < Test::Unit::TestCase

  def setup

    if ENV['browser'] != "Internet Explorer"
      browser_name = "#{ENV['browser'].capitalize} #{ENV['browser_version']}"
    else
      browser_name = "Internet Explorer #{ENV['browser_version']}"
    end

    caps = Selenium::WebDriver::Remote::Capabilities.new(
      'bstack:options': {
        "os" => ENV['os'],
        "osVersion" => ENV['os_version'],
        "projectName" => "BrowserStack",
        "buildName" => ENV['build_name'],
        "sessionName" => "Parallel Test: " + browser_name,
        "local" => "false",
        "debug"=> "true",
        "seleniumCdp"=> true,
        "seleniumVersion" => "4.1.2"
      },
      browser_name: ENV['browser'],
      browserVersion: ENV['browser_version']
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
