require_relative "../common"

class AudacityLoader < BaseLoader
  include GitLoader

  def root_path
    File.dirname(__FILE__)
  end

  def git
    "https://github.com/audacity/audacity"
  end

  def po_files
    Dir["#{workspace}/locale/*.po"]
  end

  def load
    load_git
    load_po_files
  end
end

AudacityLoader.new.load
