require_relative "../common"

class TortoiseSvnLoader < BaseLoader
  include SubversionLoader

  def root_path
    File.dirname(__FILE__)
  end

  def subversion
    "http://svn.code.sf.net/p/tortoisesvn/code/trunk/Languages/"
  end

  def po_files
    Dir["#{workspace}/*/*.po"]
  end

  def load
    load_subversion
    load_po_files
  end
end

TortoiseSvnLoader.new.load
