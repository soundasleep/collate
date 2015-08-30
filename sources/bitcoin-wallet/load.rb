require_relative "../common"

class BitcoinWallet < BaseLoader
  include GitLoader
  include AndroidLoader

  def root_path
    File.dirname(__FILE__)
  end

  def git
    "https://github.com/schildbach/bitcoin-wallet"
  end

  def values_files
    Dir["#{workspace}/wallet/res/values*/strings.xml"]
  end

  def load
    load_git
    load_values_files
  end
end

BitcoinWallet.new.load
