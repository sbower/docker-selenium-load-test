#!/usr/bin/env ruby

require 'selenium-webdriver'

def run_test
    for i in 1..20 do
        driver = Selenium::WebDriver.for(:remote,
                                         url: "http://#{ENV['HUB_IP']}:4444/wd/hub",
                                         desired_capabilities: :firefox)

        driver.navigate.to 'http://www.google.com'
        element = driver.find_element(:name, 'q')
        element.send_keys 'Shawn Bower'
        element.submit

        wait = Selenium::WebDriver::Wait.new(timeout: 10)
        wait.until { driver.title.downcase.include? 'shawn bower' }

        puts driver.title
        driver.quit
        sleep 2
    end
end

my_threads = []
for i in 1..20 do
    my_threads << Thread.new(i) do |_j|
        begin
            run_test
        rescue Exception => ex
            puts ex.message
        end
    end
    sleep 1
end

my_threads.each(&:join)
