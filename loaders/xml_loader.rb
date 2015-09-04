require "rexml/document"

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
    end.reject do |k, v|
      k.length > 300 || v.length > 300
    end.map do |k, v|
      k.gsub!(/\%1/, "%{argument}")
      v.gsub!(/\%1/, "%{argument}")
      k.gsub!(/\%2/, "%{argument2}")
      v.gsub!(/\%2/, "%{argument2}")
      k.gsub!(/\%s(\W)/, "%{string}\\1")
      v.gsub!(/\%s(\W)/, "%{string}\\1")
      k.gsub!(/\%d(\W)/, "%{number}\\1")
      v.gsub!(/\%d(\W)/, "%{number}\\1")
      [k, v]
    end.reject do |k, v|
      k.match(/\%[^{]/) || v.match(/\%[^{]/)
    end.reject do |k, v|
      k.match("--") || v.match("--")
    end.reject do |k, v|
      k.match(/<.+>/) || v.match(/<.+>/)    # strip anything with HTML
    end.map do |k, v|
      [k.strip, v.strip]
    end

    hash << ["_comment", "loaded from #{filename} by load_ts_file"]

    Hash[hash]
  end

end