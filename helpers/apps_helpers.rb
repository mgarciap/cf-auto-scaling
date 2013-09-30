module AppsHelpers

  def scale_app(app, instances)
    begin
      app.total_instances += instances
      app.update!
      puts 'Scaling successful. Lets wait a moment for the new instance to start..'
      sleep 10
    rescue  CFoundry::InstancesError
      puts 'Scaling failed'
    rescue CFoundry::AppMemoryQuotaExceeded
      puts "Update failed: You have exceeded your organization's memory limit"
    end
  end

  def app_instances app
    app.total_instances
  end

  def app_average_cpu_load app
    cpu_average = 0
    app.stats.each do |i, app_stat|
      if app_stat.keys.include? :stats
        cpu_average += app_stat[:stats][:usage][:cpu].to_f * 100
      else
        puts "Instance #{i} still booting..."
      end
    end
    cpu_average / app.total_instances
  end

  def app_average_memory app
    mem_average = 0
    app.stats.each do |stat|
      mem_average += stat[1][:stats][:usage][:mem]
    end
    mem_average / app.total_instances
  end

end