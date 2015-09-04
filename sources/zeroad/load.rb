require_relative "../common"

class ZeroadLoader < BaseLoader
  include GitLoader

  def root_path
    File.dirname(__FILE__)
  end

  def git
    "https://github.com/0ad/0ad"
  end

  def po_files
    Dir["#{workspace}/binaries/**/*.po"]
  end

  def load
    load_git
    load_po_files
  end
end

ZeroadLoader.new.load
