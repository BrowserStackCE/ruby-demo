require 'rubygems'
require 'selenium-webdriver'
require 'test-unit'
require 'browserstack/local'
require 'rest-client'

class SingleTest < Test::Unit::TestCase

  def setup

	url = "http://#{ENV["BROWSERSTACK_USER"]}:#{ENV["BROWSERSTACK_ACCESSKEY"]}@hub-cloud.browserstack.com/wd/hub"
  caps = Selenium::WebDriver::Remote::Capabilities.chrome(
    'bstack:options': {
      "os" => "Windows",
      "osVersion" => "10",
      "projectName" => "BrowserStack",
      "buildName" => "Demo Example",
      "sessionName" => "Single Selenium 4 test case",
      "local" => "false",
      "debug"=> "true",
      "seleniumCdp"=> true,
      "seleniumVersion" => "4.1.2"
    },
    chromeOptions:{
      prefs:
      {
        "profile.default_content_setting_values.geolocation" => 1
      }
    },
    autoGrantPermissions: true,
    browser_name: 'chrome',
    browserVersion: 'latest'
  )

	@driver = Selenium::WebDriver.for(:remote, :url => url, :capabilities => caps)

  end

  def test_post
    @driver.navigate.to 'https://www.bstackdemo.com/'
    iphone12 = @driver.find_element(:xpath, "//p[text()='iPhone 12']")

    puts iphone12.text

    # relative selector
    iphone12_mini = @driver.find_element(relative: {tag_name: "p", right: iphone12})
    puts iphone12.text + " is positioned to the left of " + iphone12_mini.text
    assert_equal('iPhone 12 Mini', iphone12_mini.text)

    # new tab interface
    @driver.switch_to.new_window(:tab)

    # Emulating gps coordinates via cdp
    coordinates = { latitude: 35.689487,
                  longitude: 139.691706,
                  accuracy: 100 }
    @driver.execute_cdp('Emulation.setGeolocationOverride', **coordinates)
    @driver.navigate.to 'https://www.gps-coordinates.net/my-location'
    address = @driver.find_element(:css, "#addr")
    puts address.text
    assert_match /Tokyo/, address.text

  end

  def teardown
  	api_url = "https://#{ENV["BROWSERSTACK_USER"]}:#{ENV["BROWSERSTACK_ACCESSKEY"]}@www.browserstack.com/automate/sessions/#{@driver.session_id}.json"
  	RestClient.put api_url, {"status"=>"passed"}, {:content_type => :json}
   	@driver.quit
  end

end
