require_relative "../common"

class EdxPlatformLoader < BaseLoader
  include GitLoader

  def root_path
    File.dirname(__FILE__)
  end

  def git
    "https://github.com/edx/edx-platform"
  end

  def po_files
    Dir["#{workspace}/conf/locale/**/*.po"]
  end

  def load
    load_git
    load_po_files
  end
end

EdxPlatformLoader.new.load
