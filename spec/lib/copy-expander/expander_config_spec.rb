require 'expander_config'
require 'yaml'

describe ExpanderConfig do

  include ExpanderConfig

  context 'loading configuration data' do

    it 'uses the default configuration file when none is passed' do
      load_config []
      expect(config_file).to eq('expander.yml')
    end  

    it 'uses the specified configuration file when the name is passed' do
      load_config [ 'x', 'configuration' ]
      expect(config_file).to eq('configuration.yml')
    end  

    it 'returns the value associated with a key if the key exists' do
      load_config []
      @config = { 'strange_name' => 'stored value' }
      expect(strange_name('default value')).to eq('stored value')
    end  

    it 'returns the default value when the key does not exist' do
      load_config []
      expect(strange_name('default value')).to eq('default value')
    end  

  end

end
