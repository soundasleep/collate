require_relative "../common"

class OpenclerkLoader < BaseLoader
  include GitLoader
  include JsonLoader

  def root_path
    File.dirname(__FILE__)
  end

  def git
    "https://github.com/soundasleep/openclerk"
  end

  def json_files
    Dir["#{workspace}/locale/translated/locale_*.json"]
  end

  def load
    load_git
    load_json_files
  end
end

OpenclerkLoader.new.load
