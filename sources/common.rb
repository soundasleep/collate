require "get_pomo"
require "json"
require "rexml/document"

class BaseLoader
  def workspace
    root_path + "/workspace"
  end

  def output
    root_path + "/output"
  end

  def write_json(json, lang)
    puts "Loaded #{json.keys.count} keys for #{lang}"

    if json.any?
      Dir.mkdir(output) unless Dir.exists?(output)

      outfile = "#{output}/#{lang}.json"
      File.open(outfile, "w") do |f|
        puts "Wrote file #{outfile}"
        f.write JSON.pretty_generate(json.sort.to_h)    # sorts keys
      end
    end
  end

  def passthru(command)
    system(command, out: STDOUT, err: STDERR)
  end

  def identify_language(filename)
    bits = filename.split("/")

    # remove file extension
    bits.last.gsub!(/\.([a-z]{2,3})$/, "")

    lang = identify_language_string(bits.last)

    if !lang
      # try splitting up the first _
      bits = bits.last.split("_", 2)
      lang = identify_language_string(bits.last)
    end

    if !lang
      puts "Could not identify language #{filename}"
    end

    lang
  end

  def identify_language_string(string)
    # fix invalid ISO code used by .po
    return "jp" if string == "ja"

    return string if string.match(/^[a-z]{2}$/) || string.match(/^[a-z]{2}_[A-Z]{2}$/)

    case string
      when "english"
        "en"
      when "french"
        "fr"
      when "russian"
        "ru"
      when "german"
        "de"
      when "japanese"
        "jp"
      when "chinese"
        "zh"
      when "traditional_chinese"
        "zh_TW"
      when "simplified_chinese"
        "zh_CN"
      else
        false
    end
  end

  def load_po_file(filename)
    loaded_file = File.read(filename)
    loaded_file.scrub!    # ignore invalid UTF-8 characters as necessary

    hash = GetPomo::PoFile.parse(loaded_file).map do |translation|
      if translation.plural?
        [ [translation.msgid[0], translation.msgstr[0]],
          [translation.msgid[1], translation.msgstr[1]] ]
      else
        [[ translation.msgid, translation.msgstr ]]
      end
    end.flatten(1).reject do |k, v|
      !k || !v
    end.map do |k, v|
      [k.strip, v.strip]
    end.reject do |k, v|
      k.empty? || v.empty?
    end.map do |k, v|
      k.gsub!(/\%s(\W)/, ":string\\1")
      v.gsub!(/\%s(\W)/, ":string\\1")
      k.gsub!(/\%d(\W)/, ":number\\1")
      v.gsub!(/\%d(\W)/, ":number\\1")
      [k, v]
    end.reject do |k, v|
      k.match("%") || v.match("%")
    end.map do |k, v|
      [k.strip, v.strip]
    end

    hash << ["_comment", "loaded from #{filename} by load_po_file"]

    Hash[hash]
  end

  def load_po_files
    english = {}
    languages = {}

    po_files.map do |file|
      lang = identify_language(file)
      if lang
        puts "#{file} --> #{lang}"
        languages[lang] ||= {}
        languages[lang].merge! load_po_file(file)
      end
    end

    languages.each do |lang, json|
      write_json json, lang

      # merge into english
      json.each do |k, v|
        english[k] = k
      end
    end

    write_json english, "en"
  end
end

module SubversionLoader
  def load_subversion
    puts "Checking out latest subversion #{subversion} into #{workspace}..."
    passthru "svn checkout #{subversion} #{workspace}"
  end
end

module GitLoader
  def load_git
    puts "Checking out latest Git #{git} into #{workspace}..."
    if File.exist?(workspace)
      passthru "cd #{workspace} && git pull && git checkout master"
    else
      passthru "git clone #{git} #{workspace}"
    end
  end
end

module MercurialLoader
  def load_mercurial
    puts "Checking out latest Mercurial #{mercurial} into #{workspace}..."
    if File.exist?(workspace)
      passthru "cd #{workspace} && hg pull && hg update"
    else
      passthru "hg clone #{mercurial} #{workspace}"
    end
  end
end

module XmlLoader
  include REXML

  def load_ts_files
    english = {}
    languages = {}

    ts_files.map do |file|
      lang = identify_language(file)
      if lang
        puts "#{file} --> #{lang}"
        languages[lang] ||= {}
        languages[lang].merge! load_ts_file(file)
      end
    end

    languages.each do |lang, json|
      write_json json, lang

      # merge into english
      json.each do |k, v|
        english[k] = k
      end
    end

    write_json english, "en"
  end

  def load_ts_file(filename)
    loaded_file = File.read(filename)
    loaded_file.scrub!    # ignore invalid UTF-8 characters as necessary

    xml = Document.new(loaded_file)

    hash = xml.elements.to_a("TS//message").map do |e|
      [ e.elements["source"].text, e.elements["translation"].text ]
    end.reject do |k, v|
      !k || !v
    end.map do |k, v|
      [k.strip, v.strip]
    end.reject do |k, v|
      k.empty? || v.empty?
    end.map do |k, v|
      k.gsub!(/\%1/, ":argument")
      v.gsub!(/\%1/, ":argument")
      k.gsub!(/\%2/, ":argument2")
      v.gsub!(/\%2/, ":argument2")
      k.gsub!(/\%s(\W)/, ":string\\1")
      v.gsub!(/\%s(\W)/, ":string\\1")
      k.gsub!(/\%d(\W)/, ":number\\1")
      v.gsub!(/\%d(\W)/, ":number\\1")
      [k, v]
    end.reject do |k, v|
      k.match("%") || v.match("%")
    end.map do |k, v|
      [k.strip, v.strip]
    end

    hash << ["_comment", "loaded from #{filename} by load_ts_file"]

    Hash[hash]
  end

end
