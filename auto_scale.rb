#!/usr/bin/env ruby

require 'cfoundry'
require_relative 'helpers/stats_helpers'
require_relative 'helpers/apps_helpers'
require 'yaml'

include StatsHelpers
include AppsHelpers

config = YAML.load_file('config/config.yml')


puts "Cloudfoundry target: #{config['target']}"
client = CFoundry::Client.get config['target']

puts "Authenticating with user: #{config['username']}"
client.login :username => config['username'], :password => config['password']

puts 'Fetching first space...' #ToDo: provide options from the user
space = client.spaces(:depth => 0).first
puts "Got space: #{space.name}"
puts

puts "Fetching first app from space #{space.name} ..." #ToDo: provide options from the user
app = space.apps.first
puts "Got app: #{app.name} (#{app.routes.first.name})"
puts

threshold = 70
puts "CPU threshold: #{threshold}%"
puts "-"*30

while true do
  avg_cpu_load = app_average_cpu_load app
  avg_mem = app_average_memory app

  puts "App #{app.name} stats:"
  puts "-- Instances: #{app.total_instances}"
  puts "-- AVG CPU load: #{humanise_cpu_usage avg_cpu_load}"
  puts "-- AVG Memory: #{humanise_bytes_to_megabytes avg_mem}"
  puts
  puts "------------> AVG CPU Load went over threshold (#{threshold} %), scaling app by 1 instance" if avg_cpu_load >= threshold
  scale_app(app, 1) if avg_cpu_load >= threshold

  sleep 2.0
end
