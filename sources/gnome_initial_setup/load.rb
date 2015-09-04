require_relative "../common"

class GnomeInitialSetupLoader < BaseLoader
  include GitLoader

  def root_path
    File.dirname(__FILE__)
  end

  def git
    "https://github.com/GNOME/gnome-initial-setup"
  end

  def po_files
    Dir["#{workspace}/po/*.po"]
  end

  def load
    load_git
    load_po_files
  end
end

GnomeInitialSetupLoader.new.load
