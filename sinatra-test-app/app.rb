require 'rubygems'
require 'sinatra'
require 'securerandom'

get '/' do
  t1 = Time.now

  host = ENV['VCAP_APP_HOST']
  port = ENV['VCAP_APP_PORT']

  ret = "<h1>Sinatra simple app for Autoscaling testing..</h1>"
  ret += "Running from #{host}:#{port}! <br/>"
  ret += "<h4> CPU load </h4>"
  ret += "<p>Lets generate some CPU load by generating some random strings </p>"

  20000.times do
    SecureRandom.hex(2048)
  end

  #200.times do
  #  ret += "#{SecureRandom.hex(64)}<br/>"
  #end
  t2 = Time.now

  ret += "<hr>"
  ret += "<p> It took #{(t2 - t1) * 1000.0} milliseconds"
  ret
end
