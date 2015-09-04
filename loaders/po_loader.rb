require "get_pomo"

module PoLoader
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
    end.reject do |k, v|
      k.length > 300 || v.length > 300
    end.map do |k, v|
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
        begin
          languages[lang].merge! load_po_file(file)
        rescue => e
          puts "Error loading #{file}: #{e}"
        end
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
