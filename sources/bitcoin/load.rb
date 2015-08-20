require_relative "../common"

class GitSourceLoader < BaseLoader
  include GitLoader
  include XmlLoader

  def root_path
    File.dirname(__FILE__)
  end

  def git
    "https://github.com/bitcoin/bitcoin"
  end

  def ts_files
    Dir["#{workspace}/src/qt/locale/*.ts"]
  end

  def load
    load_git
    load_ts_files
  end
end

GitSourceLoader.new.load
