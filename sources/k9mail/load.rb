require_relative "../common"

class K9MailLoader < BaseLoader
  include GitLoader
  include AndroidLoader

  def root_path
    File.dirname(__FILE__)
  end

  def git
    "https://github.com/k9mail/k-9"
  end

  def values_files
    Dir["#{workspace}/k9mail/src/main/res/values*/strings.xml"]
  end

  def load
    load_git
    load_values_files
  end
end

K9MailLoader.new.load
