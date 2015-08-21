require_relative "../common"

class BzflagLoader < BaseLoader
  include GitLoader

  def root_path
    File.dirname(__FILE__)
  end

  def git
    "https://github.com/BZFlag-Dev/bzflag"
  end

  def po_files
    Dir["#{workspace}/data/l10n/*.po"]
  end

  def load
    load_git
    load_po_files
  end
end

BzflagLoader.new.load
