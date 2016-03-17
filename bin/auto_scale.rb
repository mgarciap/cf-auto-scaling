#!/usr/bin/env ruby

$LOAD_PATH.unshift('helpers')
$LOAD_PATH.unshift('lib')

require 'yaml'
require 'cfoundry'
require 'stats_helpers'
require 'apps_helpers'
require 'cloud_foundry_manager'

include StatsHelpers
include AppsHelpers

config = CloudFoundryManager.config
puts "Cloudfoundry target: #{config.api}"
puts "Authenticating with user: #{config.username}"

app = CloudFoundryManager.application

puts "Application fetched: #{app.name} (#{app.routes.first.name})"
puts

threshold = 70
puts "CPU threshold: #{threshold}%"
puts "-"*30
puts

threshold = 70
puts "Memory threshold: #{threshold}%"
puts "-"*30
puts

while true do
  avg_cpu_load = app_average_cpu_load app
  avg_mem = app_average_memory app

  puts "App #{app.name} stats:"
  puts "-- Instances: #{app.total_instances}"
  puts "-- AVG CPU load: #{humanise_cpu_usage avg_cpu_load}"
  puts "-- AVG Memory: #{humanise_bytes_to_megabytes avg_mem}"
  puts
  if avg_cpu_load >= threshold
    puts "------------> AVG CPU Load went over threshold (#{threshold} %), scaling app by 1 instance"
    scale_app(app, 1)
  end
  if avg_mem >= threshold
    puts "------------> AVG MEM Load went over threshold (#{threshold} %), scaling app by 1 instance"
    scale_app(app, 1)
  end
  app.stats.each do |i, app_stat|
    if app_stat.keys.include? :stats
      i_used = app_stat[:stats][:usage][:mem]
      i_quota = app_stat[:stats][:mem_quota]
      i_perc = i_used * 100 / i_quota
      #puts "Instance #{i} use: #{humanise_bytes_to_megabytes i_use}"
      #puts "Instance #{i} quota: #{humanise_bytes_to_megabytes i_quota}"
      puts "#{config.application} - #{i} use: #{i_perc}%"
    else
      puts "Instance #{i} still booting..."
    end
  end

  sleep 2.0
end
