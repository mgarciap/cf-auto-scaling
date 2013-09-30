module StatsHelpers
  def humanise_cpu_usage number
    "%.2f %" % number
  end

  def humanise_bytes_to_megabytes bytes
    "%.2f MB" % bytes_to_megabytes(bytes)
  end

  def bytes_to_megabytes bytes
    (bytes / 1024.0) / 1024.0
  end
end