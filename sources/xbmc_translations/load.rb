require_relative "../common"

class XbmcTranslations < BaseLoader
  include GitLoader

  def root_path
    File.dirname(__FILE__)
  end

  def git
    "https://github.com/xbmc/translations"
  end

  def po_files
    Dir["#{workspace}/translations/**/language/**/*.po"]
  end

  def load
    load_git
    load_po_files
  end
end

XbmcTranslations.new.load
