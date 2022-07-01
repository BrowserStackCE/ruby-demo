require 'rubygems'
require 'selenium-webdriver'
require 'test-unit'
require 'browserstack/local'
require 'rest-client'

class SingleTest < Test::Unit::TestCase

  def setup

  caps = Selenium::WebDriver::Remote::Capabilities.new(
    'bstack:options': {
      "os" => "Windows",
      "osVersion" => "10",
      "projectName" => "BrowserStack",
      "buildName" => "Demo Example",
      "sessionName" => "Single test case",
      "local" => "false",
      "debug"=> "true",
      "seleniumCdp"=> true,
      "seleniumVersion" => "4.1.2"
    },
    browser_name: 'chrome',
    browserVersion: 'latest'
  )
  
  url = "https://#{ENV["BROWSERSTACK_USER"]}:#{ENV["BROWSERSTACK_ACCESSKEY"]}@hub-cloud.browserstack.com/wd/hub"
	@driver = Selenium::WebDriver.for(:remote, :url => url, :capabilities => caps)

  end

  def test_post
	@driver.navigate.to 'http://www.google.com'

	search_bar = @driver.find_element(:name, "q")
	search_bar.send_keys 'BrowserStack'
	search_bar.submit

	first_result = @driver.find_element(:css, "h3.r a")
	first_result.click

	title = @driver.title
	assert_equal(title, title)

  end

  def teardown
  	api_url = "https://#{ENV["BROWSERSTACK_USER"]}:#{ENV["BROWSERSTACK_ACCESSKEY"]}@www.browserstack.com/automate/sessions/#{@driver.session_id}.json"
  	RestClient.put api_url, {"status"=>"passed"}, {:content_type => :json}
   	@driver.quit
  end

end
