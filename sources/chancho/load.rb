require_relative "../common"

class ChanchoLoader < BaseLoader
  include GitLoader

  def root_path
    File.dirname(__FILE__)
  end

  def git
    "https://github.com/mandel-macaque/chancho"
  end

  def po_files
    Dir["#{workspace}/src/public/gui/app/po/*.po"]
  end

  def load
    load_git
    load_po_files
  end
end

ChanchoLoader.new.load
