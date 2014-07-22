class Configuration

  def self.config_options
    %w(username password api organization space application profile)
  end

  def self.default_options
    {profile: false}
  end

  config_options.each do |option|
    attr_accessor option
  end

  def initialize(file_path)
    file_config = File.exists?(file_path) ? YAML.load_file(file_path) : {}
    @config = self.class.default_options.merge(file_config)
    self.class.config_options.each do |option|
      self.send(:"#{option}=", ENV["CF_#{option.upcase}"] || @config[option])
    end
  end

end
