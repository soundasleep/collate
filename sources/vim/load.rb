require_relative "../common"

class VimLoader < BaseLoader
  include MercurialLoader

  def root_path
    File.dirname(__FILE__)
  end

  def mercurial
    "https://vim.googlecode.com/hg/"
  end

  def po_files
    Dir["#{workspace}/src/po/*.po"]
  end

  def load
    load_mercurial
    load_po_files
  end
end

VimLoader.new.load
