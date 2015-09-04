require_relative "../common"

class GnomeGimp < BaseLoader
  include GitLoader

  def root_path
    File.dirname(__FILE__)
  end

  def git
    "https://github.com/GNOME/gimp"
  end

  def po_files
    Dir["#{workspace}/po*/*.po"]
  end

  def load
    load_git
    load_po_files
  end
end

GnomeGimp.new.load
