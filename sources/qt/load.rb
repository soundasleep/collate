require_relative "../common"

class QtLoader < BaseLoader
  include GitLoader
  include XmlLoader

  def root_path
    File.dirname(__FILE__)
  end

  def git
    "https://github.com/MythTV/mythtv"
  end

  def ts_files
    Dir["#{workspace}/translations/*.ts"]
  end

  def load
    load_git
    load_ts_files
  end

end

QtLoader.new.load
