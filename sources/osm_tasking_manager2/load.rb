require_relative "../common"

class OsmTaskingManager2Loader < BaseLoader
  include GitLoader

  def root_path
    File.dirname(__FILE__)
  end

  def git
    "https://github.com/hotosm/osm-tasking-manager2"
  end

  def po_files
    Dir["#{workspace}/osmtm/locale/**/*.po"]
  end

  def load
    load_git
    load_po_files
  end
end

OsmTaskingManager2Loader.new.load
