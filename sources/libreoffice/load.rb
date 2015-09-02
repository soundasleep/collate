require_relative "../common"

class LibreofficeLoader < BaseLoader
  include GitLoader

  def root_path
    File.dirname(__FILE__)
  end

  def git
    "git://anongit.freedesktop.org/libreoffice/translations"
  end

  def po_files
    Dir["#{workspace}/source/**/*.po"]
  end

  def load
    load_git
    load_po_files
  end

  def identify_language(filename)
    filename.match(/workspace\/source\/([a-z]{2})\//) do |match|
      lang = match[1]
      lang = "jp" if lang == "ja"
      lang
    end
  end
end

LibreofficeLoader.new.load
