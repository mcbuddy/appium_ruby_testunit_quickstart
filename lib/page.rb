# ../lib/page.rb

module Page
  def self.wait(loc,time = 5)
    $wait.until { sleep(time)|| $driver.find_element(loc.displayed? )}
  end


end