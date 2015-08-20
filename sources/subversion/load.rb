require_relative "../common"

class SubversionSourceLoader < BaseLoader
  include SubversionLoader

  def root_path
    File.dirname(__FILE__)
  end

  def subversion
    "http://svn.apache.org/repos/asf/subversion/trunk/subversion/po/"
  end

  def po_files
    Dir["#{workspace}/*.po"]
  end

  def load
    load_subversion
    load_po_files
  end
end

SubversionSourceLoader.new.load
