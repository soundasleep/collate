require_relative "../common"

class GnomePowerManager < BaseLoader
  include GitLoader

  def root_path
    File.dirname(__FILE__)
  end

  def git
    "git@github.com:GNOME/gnome-power-manager.git"
  end

  def load
    load_git

    english = {}

    # load all .po
    Dir["#{workspace}/po/*.po"].map do |file|
      lang = identify_language(file)
      if lang
        puts "#{file} --> #{lang}"

        json = load_po_file(file)
        write_json json, lang

        # merge into english
        json.each do |k, v|
          english[k] = k
        end
      end
    end

    write_json english, "en"
  end
end

GnomePowerManager.new.load
