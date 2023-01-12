require 'rubygems'
require 'rest-client'
require 'json'

user = ENV["BROWSERSTACK_USER"]
key = ENV["BROWSERSTACK_ACCESSKEY"]

# API base URL
	base_url = "https://#{user}:#{key}@api.browserstack.com/app-automate/"



# Upload App
	puts "(1) Uploading App...."
	results = RestClient.post(
		base_url + "upload",
		file: File.new("./app/apps/BrowserStack-SampleApp.ipa", 'rb')
	)
	app_url = JSON.parse(results.body)['app_url']



# Upload Tests
	puts "(2) Uploading Test Suite...."
	results = RestClient.post(
		base_url + "xcuitest/test-suite",
		file: File.new("./app/apps/BrowserStack-SampleXCUITest.zip", 'rb')
	)
	test_url = JSON.parse(results.body)['test_url']



# Execute Tests
	puts "(3) Launching Build."
	RestClient.post(
		base_url + "xcuitest/build",
		{ 
			"app": app_url, 
			"testSuite": test_url,
			"devices": [
				"iPhone 8-11",
				"iPhone X-11"
			], 
			"deviceLogs": true 
		}.to_json,
		content_type: :json
	)


