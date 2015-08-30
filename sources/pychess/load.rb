require_relative "../common"

class PychessLoader < BaseLoader
  include GitLoader

  def root_path
    File.dirname(__FILE__)
  end

  def git
    "https://github.com/pychess/pychess"
  end

  def po_files
    Dir["#{workspace}/lang/*/LC_MESSAGES/*.po"]
  end

  def load
    load_git
    load_po_files
  end
end

PychessLoader.new.load
