# Prep ENV
		require 'json'
		require 'rest-client'
		require 'yaml'
		require 'time'

		config = YAML.load(File.read("config.yml"))
		ENV['BROWSERSTACK_USER'] = config['BROWSERSTACK_USER']
		ENV['BROWSERSTACK_ACCESSKEY'] = config['BROWSERSTACK_ACCESSKEY']


# Automate - Single Test
		task :single do
			system "ruby web/single.rb"
		end



# Automate - Parallel Tests
		browser_list = File.read('web/browsers/browsers.json')
		browsers = JSON.parse(browser_list)['browsers']
		parallel_tests = Array.new
		build_name = "Demo parallel - "+ Time.now.strftime("%Y-%m-%d")

		def run_parallel_test(browser,build_name)
			command =  "os=\"#{browser['os']}\" "
			command += "os_version=\"#{browser['os_version']}\" "
			command += "browser=\"#{browser['browser']}\" "
			command += "browser_version=\"#{browser['browser_version']}\" "	
			command += "build_name=\"#{build_name}\" "
			command += "ruby web/parallel.rb"
			system command
		end

		browsers.each_with_index do |browser, i|
			eval "parallel_tests << :parallel_test#{i}"
			eval "task :parallel_test#{i} do run_parallel_test(#{browser},\"#{build_name}\") end"
		end

		multitask :parallel => parallel_tests



# Automate - Local Test
		task :local do
			system "ruby web/local.rb"
		end



# Automate - Failed Test with API marker
		task :fail do
			system 'ruby web/fail.rb'
		end



# Automate - Mobile Web tests
		device_list = File.read('web/browsers/devices.json')
		devices = JSON.parse(device_list)['devices']
		mobile_tests = Array.new
		build_name = "Demo mobile - "+ Time.now.strftime("%Y-%m-%d")

		def run_mobile_test(device,build_name)
			command = "device=\"#{device['device']}\" "
			command += "build_name=\"#{build_name}\" "
			command += "os_version=\"#{device['os_version']}\" " if device['os_version']
			command += "ruby web/mobile.rb"
			system command
		end

		devices.each_with_index do |device, i|
			eval "mobile_tests << :mobile_test#{i}"
			eval "task :mobile_test#{i} do run_mobile_test(#{device},\"#{build_name}\") end"
		end

		multitask :mobile => mobile_tests



# App Automate - Android Appium Test
		task :appium do
			puts "Checking for uploaded apps..."
			prev_uploads = RestClient.get "https://#{ENV["BROWSERSTACK_USER"]}:#{ENV["BROWSERSTACK_ACCESSKEY"]}@api.browserstack.com/app-automate/recent_apps/DemoApp"
			prev_uploads = JSON.parse(prev_uploads)

			if prev_uploads.class != Array || prev_uploads.size == 0
				puts "No previous apps found. Uploading app..."
				puts RestClient.post(
					"https://#{ENV["BROWSERSTACK_USER"]}:#{ENV["BROWSERSTACK_ACCESSKEY"]}@api.browserstack.com/app-automate/upload",
					{ 
						file: File.new("./app/apps/WikipediaSample.apk", 'rb'),
						data: {"custom_id": "DemoApp"}.to_json
					}
				)
			else
				puts "Using Previously Uploaded App:\n" + prev_uploads.last.to_s
			end
			system 'ruby app/appium.rb'
		end



# App Automate - Android Espresso Test
		task :espresso do
			system 'ruby app/espresso.rb'
		end



# App Automate - iOS XCUITest Test
		task :xcuitest do
			system 'ruby app/xcuitest.rb'
		end

