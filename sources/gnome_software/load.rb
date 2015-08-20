require_relative "../common"

class GnomeSoftwareLoader < BaseLoader
  include GitLoader

  def root_path
    File.dirname(__FILE__)
  end

  def git
    "https://github.com/GNOME/gnome-software"
  end

  def po_files
    Dir["#{workspace}/po/*.po"]
  end

  def load
    load_git
    load_po_files
  end
end

GnomeSoftwareLoader.new.load
