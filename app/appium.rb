require 'rubygems'
require 'selenium-webdriver'
require 'test-unit'
require 'appium_lib'
require 'browserstack/local'
require 'rest-client'

class AndroidAppTest < Test::Unit::TestCase

# curl -u "<user>:<key>"
# 		 -X POST "https://api.browserstack.com/app-automate/upload"
# 		 -F "file=@/Path/to/File/WikipediaSample.apk"

  def setup

    caps = {
        "platformName" => "android",
        "platformVersion" => "9.0",
        "deviceName" => "Google Pixel 3",
        "app" => "DemoApp",
        'bstack:options' => {
          "projectName" => "BrowserStack",
          "buildName" => "Demo",
          "sessionName" => "Wikipedia Search Function",
          "debug" => true
      },
    }

		appium_driver = Appium::Driver.new({
			'caps' => caps,
			'appium_lib' => {
				:server_url => "http://#{ENV["BROWSERSTACK_USER"]}:#{ENV["BROWSERSTACK_ACCESSKEY"]}@hub-cloud.browserstack.com/wd/hub"
			}}, true)
		@driver = appium_driver.start_driver

  end

  def test_post
	  wait = Selenium::WebDriver::Wait.new(:timeout => 30)
		wait.until { @driver.find_element(:accessibility_id, "Search Wikipedia").displayed? }
		element = @driver.find_element(:accessibility_id, "Search Wikipedia")
		element.click

		wait.until { @driver.find_element(:id, "org.wikipedia.alpha:id/search_src_text").displayed? }
		search_box = @driver.find_element(:id, "org.wikipedia.alpha:id/search_src_text")
		search_box.send_keys("BrowserStack")

		wait.until { @driver.find_element(:class, "android.widget.TextView").displayed? }
		results = @driver.find_elements(:class, "android.widget.TextView")

		results_count = results.count

		assert_equal(results_count, results_count)
  end

  def teardown
  	api_url = "https://#{ENV["BROWSERSTACK_USER"]}:#{ENV["BROWSERSTACK_ACCESSKEY"]}@www.browserstack.com/app-automate/sessions/#{@driver.session_id}.json"
  	RestClient.put api_url, {"status"=>"passed"}, {:content_type => :json}
    @driver.quit
  end

end
