# Need for local machine or add this to jenkins script
# Connect your device or start your emulator before running this script
# killall -9 node to kill all node instances

# for Android emulator:
#start appium server for chrome pkg and redirect stderr and stdout to keep terminal clean
# `appium --app-pkg com.android.chrome`
# to prepare device
# `adb kill-server`
# `adb devices`

# For iOS emulator:
# `appium --safari`

# make sure appium and chromedriver aren't started yet.
# `killall node`
# `killall chromedriver`
# `killall iosdriver`
# `killall safaridriver`


require 'rubygems'
require 'test-unit'
require 'selenium-webdriver'
require 'yaml'
require_relative "spec/#{ARGV[1]}.rb"

class MobileRunner < Test::Unit::TestCase
  $var = YAML::load(File.read(File.expand_path("../config/#{ARGV[0]}.yml", __FILE__)))

  case ARGV[2]
    when 'android-chrome'
      $capabilities = { :app => 'chrome', :device => 'Android' }
      $server_url = 'http://localhost:4723/wd/hub/'

    when 'android-native'
      $capabilities = { 'app-package' => 'com.jackthreads.android',
                        'app-activity' => 'activities.SplashActivity',
                        'app-wait-activity' => 'activities.SplashActivity',
                        :device => 'Android' }

    when 'ios-safari'
      $capabilities = { :platform => 'Mac 10.10', :version => '7.1', 'platformName' => 'iOS',
      :deviceName => 'iPhone Simulator', :app => 'safari' }
      $server_url = 'http://localhost:4723/wd/hub/'

    when 'ios-native'
      $capabilities = { :app => '', :device => 'ios' }
    else
      raise('Wrong argument please check your call again')
  end

  def setup
    #Setup webdrivers to talk to Appium and mobile chrome and use implicit_waits to poll with long timeout to see if pages are loaded
    $driver = Selenium::WebDriver.for(:remote, :desired_capabilities => $capabilities, :url => $server_url)#, :profile => profile)
    $driver.manage.timeouts.implicit_wait = 120
    $wait = Selenium::WebDriver::Wait.new(:timeout => 180)
  end

  def test_page
    running_test($var)
  end

  def teardown
    $driver.quit
  end

end
