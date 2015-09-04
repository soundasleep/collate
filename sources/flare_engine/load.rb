require_relative "../common"

class FlareEngineLoader < BaseLoader
  include GitLoader

  def root_path
    File.dirname(__FILE__)
  end

  def git
    "https://github.com/clintbellanger/flare-engine"
  end

  def po_files
    Dir["#{workspace}/**/*.po"]
  end

  def load
    load_git
    load_po_files
  end
end

FlareEngineLoader.new.load
