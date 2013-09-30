module AppsHelpers

  def scale_app(app, instances)
    begin
      app.total_instances = instances
      app.update!
      puts 'Update successful'
    rescue  CFoundry::InstancesError
      puts 'Update failed'
    rescue CFoundry::AppMemoryQuotaExceeded
      puts "Update failed: You have exceeded your organization's memory limit"
    end
  end

  def app_instances app
    app.total_instances
  end

  def app_average_cpu_load app
    cpu_average = 0
    app.stats.each do |stat|
      cpu_average += stat[1][:stats][:usage][:cpu].to_i * 100
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