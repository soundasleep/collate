require_relative "../common"

class GnomeI18nLoader < BaseLoader
  include GitLoader

  def root_path
    File.dirname(__FILE__)
  end

  def git
    "https://github.com/GNOME/gnome-i18n"
  end

  def po_files
    Dir["#{workspace}/**/*.po"]
  end

  def load
    load_git
    load_po_files
  end
end

GnomeI18nLoader.new.load
