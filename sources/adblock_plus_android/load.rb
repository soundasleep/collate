require_relative "../common"

class AdblockPlusAndroidLoader < BaseLoader
  include GitLoader
  include AndroidLoader

  def root_path
    File.dirname(__FILE__)
  end

  def git
    "https://github.com/adblockplus/adblockplusandroid"
  end

  def values_files
    Dir["#{workspace}/res/values*/strings.xml"]
  end

  def load
    load_git
    load_values_files
  end
end

AdblockPlusAndroidLoader.new.load
