#!/usr/bin/env ruby

require 'cfoundry'
require_relative 'helpers/stats_helpers'
require_relative 'helpers/apps_helpers'
require_relative 'helpers/configuration'
require 'yaml'

include StatsHelpers
include AppsHelpers

config = YAML.load_file('config/config.yml')

config = Configuration.new('config/config.yml')

# username = config['username'] || ENV['CF_USERNAME']
# password = config['password'] || ENV['CF_PASSWORD']
# cf_api = config['target'] || ENV['CF_API']


puts "Cloudfoundry target: #{cf_api}"
client = CFoundry::Client.get(config.api)

puts "Authenticating with user: #{username}"


client.login :username => config.username, :password => config.password

organization = client.organizations.find {|org| org.name == config.organization}
raise "Can't find organization called \"#{config.organization}\"" if organization.nil? 
space = organization.spaces.find {|space| space.name == config.space}
raise "Can't find space called \"#{config.organization}\"" if space.nil? 
@app = space.organizations.find {|app| org.name == config.application}
raise "Can't find app called \"#{config.organization}\"" if @app.nil? 

puts "Application fetched: #{@app.name} (#{@app.routes.first.name})"
puts

threshold = 70
puts "CPU threshold: #{threshold}%"
puts "-"*30
puts

while true do
  avg_cpu_load = app_average_cpu_load @app
  avg_mem = app_average_memory @app

  puts "App #{@app.name} stats:"
  puts "-- Instances: #{@app.total_instances}"
  puts "-- AVG CPU load: #{humanise_cpu_usage avg_cpu_load}"
  puts "-- AVG Memory: #{humanise_bytes_to_megabytes avg_mem}"
  puts
  puts "------------> AVG CPU Load went over threshold (#{threshold} %), scaling app by 1 instance" if avg_cpu_load >= threshold
  scale_app(@app, 1) if avg_cpu_load >= threshold

  sleep 2.0
end
