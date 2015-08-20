require_relative "../common"

class MythTvLoader < BaseLoader
  include GitLoader
  include XmlLoader

  def root_path
    File.dirname(__FILE__)
  end

  def git
    "https://github.com/mythtv/mythtv"
  end

  def ts_files
    Dir["#{workspace}/mythplugins/*/i18n/*.ts"]
  end

  def load
    load_git
    load_ts_files
  end
end

MythTvLoader.new.load
