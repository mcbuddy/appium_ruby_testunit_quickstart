# ../spec/search_spec.rb

require_relative '../lib/page'

def running_test(var)
    # go to google.com
    $driver.get(var['URI'])

    # query the 'Appium' on google search
    $driver.find_element(var['PAGE']['SEARCH_BAR']).send_key('Appium')
    $driver.find_element(var['PAGE']['SEARCH_BUTTON']).click

    # wait for the page loaded
    Page.wait(var['PAGE']['FIRST_ROW'])

    # validate the Appium appear on the search result
    assert($driver.find_element(var['PAGE']['FIRST_LINE']).text.eql? 'Appium')
end