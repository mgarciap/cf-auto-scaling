class Configuration

  def self.config_options
    %w(username password api organization space application)
  end

  config_options.each do |option|
    attr_accessor option
  end

  def initialize(file_path)
    @config = File.exists?(file_path) ? YAML.load_file('config/config.yml') : {}
    self.class.config_options.each do |option|
      self.send(:"#{option}=", ENV["CF_#{option.upcase}"] || @config[option])
    end
  end

end