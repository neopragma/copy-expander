require 'yaml'
require_relative '../lib/expander_config'

##
# Load and manage configuration settings
#
module ExpanderConfig

  def load_config argv
    @config_file = argv.length > 1 ? "#{argv[1]}.yml" : 'expander.yml'
    @config = File.exist?(@config_file) ? YAML.load_file(@config_file) : @config = {}
    @config
  end

  def config_file
    @config_file
  end  

  def hash
    @config
  end  

  def method_missing(method_name, *args, &block)
    @config.has_key?("#{method_name}") ? @config["#{method_name}"] : args[0]
  end

end