require_relative "../common"

class PootleLoader < BaseLoader
  include GitLoader

  def root_path
    File.dirname(__FILE__)
  end

  def git
    "https://github.com/translate/pootle"
  end

  def po_files
    Dir["#{workspace}/pootle/locale/**/*.po"]
  end

  def load
    load_git
    load_po_files
  end
end

PootleLoader.new.load
