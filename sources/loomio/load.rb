require_relative "../common"

class LoomioLoader < BaseLoader
  include GitLoader
  include YamlLoader

  def root_path
    File.dirname(__FILE__)
  end

  def git
    "https://github.com/loomio/loomio"
  end

  def yaml_files
    Dir["#{workspace}/config/locales/*.yml"]
  end

  def load
    # load_git
    load_yaml_files
  end
end

LoomioLoader.new.load
