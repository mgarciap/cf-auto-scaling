require 'configuration'

class CloudFoundryManager

  def self.config
    @config ||= Configuration.new('config/config.yml')
  end

  def self.client
    @default_client ||= begin 
      CFoundry::Client.get(config.api).tap do |client| 
        client.login(username: config.username, password: config.password)
        client.base.rest_client.log = STDOUT if config.profile
      end
    end
  end

  def self.organization(name = config.organization)
    self.client.organizations.find {|org| org.name == name}
  end

  def self.space(name = config.space)
    self.organization.spaces.find {|space| space.name == name}
  end
  
  def self.application(name = config.application)
    self.space.apps.find {|app| app.name == name}
  end

end
