require 'rubygems'
require 'selenium-webdriver'
require 'test-unit'
require 'browserstack/local'
require 'rest-client'

class LocalTest < Test::Unit::TestCase

  def setup
    caps = Selenium::WebDriver::Remote::Capabilities.new(
      'bstack:options': {
        "os" => "Windows",
        "osVersion" => "10",
        "projectName" => "BrowserStack",
        "buildName" => "Demo Example",
        "sessionName" => "Local test",
        "local" => "true",
        "debug"=> "true",
        "seleniumCdp"=> true,
        "seleniumVersion" => "4.1.2"
      },
      browser_name: 'IE',
      browserVersion: '11.0'
    )

		bs_local_args = { "key" => "#{ENV["BROWSERSTACK_ACCESSKEY"]}", "forcelocal" => true, "force" => true }
		@bs_local = BrowserStack::Local.new
		@bs_local.start(bs_local_args)

    url = "http://#{ENV["BROWSERSTACK_USER"]}:#{ENV["BROWSERSTACK_ACCESSKEY"]}@hub-cloud.browserstack.com/wd/hub"
    @driver = Selenium::WebDriver.for(:remote, :url => url, :capabilities => caps)

  end

  def test_post
		@driver.navigate.to "http://localhost:8000"
    title = @driver.title()
    assert_equal("Local Server", title)
  end

  def teardown
  	api_url = "https://#{ENV["BROWSERSTACK_USER"]}:#{ENV["BROWSERSTACK_ACCESSKEY"]}@www.browserstack.com/automate/sessions/#{@driver.session_id}.json"
  	RestClient.put api_url, {"status"=>"passed"}, {:content_type => :json}
    @driver.quit
    @bs_local.stop unless @bs_local.nil?
  end

end
