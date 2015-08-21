require_relative "../common"

class OpenttdLoader < BaseLoader
  include SubversionLoader

  def root_path
    File.dirname(__FILE__)
  end

  def subversion
    "http://svn.openttd.org/trunk/src/lang/"
  end

  def load
    load_subversion

    english = load_openttd_file("#{workspace}/english.txt")

    # load all .txt
    Dir["#{workspace}/*.txt"].map do |file|
      lang = identify_language(file)
      if lang
        puts "#{file} --> #{lang}"

        loaded = load_openttd_file(file)

        json = {}
        loaded.each do |key, value|
          if english.has_key?(key)
            english_key = english[key]
            json[english_key] = value
          else
            # puts "Warning: Could not find key '#{key}' in english for #{lang}"
          end
        end

        write_json json, lang
      end
    end
  end

  def load_openttd_file(filename)
    pattern = /^([A-Z0-9_]+)\s+:(.+)/

    hash = File.open(filename).each_line.map(&:strip).select do |line|
      line.match pattern
    end.map do |line|
      line.match(pattern) do |match|
        [match[1], match[2]]
      end
    end.map do |k, v|
      # replace common arguments
      v.gsub! "{STRING}", "%{string}"
      v.gsub! "{STRING1}", "%{string1}"
      v.gsub! "{STRING2}", "%{string1}"
      v.gsub! "{NUM}", "%{num}"
      v.gsub! "{NUMBER}", "%{number}"
      v.gsub! "{VELOCITY}", "%{velocity}"
      v.gsub! "{TOWN}", "%{town}"
      v.gsub! "{TRAIN}", "%{train}"
      v.gsub! "{VEHICLE}", "%{vehicle}"
      [k, v]
    end.map do |k, v|
      # colours should not really be in here
      v.gsub! "{BLACK}", ""
      v.gsub! "{WHITE}", ""
      v.gsub! "{RED}", ""
      v.gsub! "{BLUE}", ""
      v.gsub! "{LTBLUE}", ""
      v.gsub! "{YELLOW}", ""
      v.gsub! "{GOLD}", ""
      v.gsub! "{ORANGE}", ""
      v.gsub! "{SILVER}", ""
      v.gsub! "{TINYFONT}", ""
      [k, v]
    end.select do |k, v|
      !v.match(/[^%]\{/) && !v.match(/^\{/)
    end

    hash << ["_comment", "loaded from #{filename} by load_openttd_file"]

    Hash[hash]
  end

end

OpenttdLoader.new.load
