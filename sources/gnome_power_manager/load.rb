require_relative "../common"

class GnomePowerManagerLoader < BaseLoader
  include GitLoader

  def root_path
    File.dirname(__FILE__)
  end

  def git
    "git@github.com:GNOME/gnome-power-manager.git"
  end

  def po_files
    Dir["#{workspace}/po/*.po"]
  end

  def load
    load_git
    load_po_files
  end
end

GnomePowerManagerLoader.new.load
