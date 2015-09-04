require "rexml/document"

module AndroidLoader
  include REXML

  def load_values_files
    english = {}
    languages = {}

    values_files.map do |file|
      lang = identify_language(file)
      if lang
        puts "#{file} --> #{lang}"

        english_xml ||= load_english_values_file(file)

        languages[lang] ||= {}
        languages[lang].merge! load_values_file(file, english_xml)
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

  def load_english_values_file(filename)
    loaded_file = File.read(english_values_file_for(filename))
    loaded_file.scrub!    # ignore invalid UTF-8 characters as necessary

    xml = Document.new(loaded_file)

    hash = xml.elements.to_a("/resources/string").map do |e|
      [ e.attributes["name"], e.text ]
    end

    Hash[hash]
  end

  def english_values_file_for(filename)
    File.dirname(filename) + "/../values/strings.xml"
  end

  def load_values_file(filename, english_hash)
    loaded_file = File.read(filename)
    loaded_file.scrub!    # ignore invalid UTF-8 characters as necessary

    xml = Document.new(loaded_file)

    hash = xml.elements.to_a("/resources/string").map do |e|
      attribute = e.attributes["name"]
      en = english_hash[attribute]
      [ en, e.text ]
    end.reject do |k, v|
      !k || !v
    end.map do |k, v|
      [k.strip, v.strip]
    end.reject do |k, v|
      k.empty? || v.empty?
    end.reject do |k, v|
      k.length > 300 || v.length > 300
    end.map do |k, v|
      k.gsub!(/\%1\$s/, "%{string}")
      v.gsub!(/\%1\$s/, "%{string}")
      k.gsub!(/\%2\$s/, "%{string2}")
      v.gsub!(/\%2\$s/, "%{string2}")
      k.gsub!(/\%1\$d/, "%{number}")
      v.gsub!(/\%1\$d/, "%{number}")
      k.gsub!(/\%2\$d/, "%{number2}")
      v.gsub!(/\%2\$d/, "%{number2}")
      k.gsub!(/\%1(|\$.)/, "%{argument}")
      v.gsub!(/\%1(|\$.)/, "%{argument}")
      k.gsub!(/\%2(|\$.)/, "%{argument2}")
      v.gsub!(/\%2(|\$.)/, "%{argument2}")
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

    hash << ["_comment", "loaded from #{filename} by load_values_file"]

    Hash[hash]
  end

end