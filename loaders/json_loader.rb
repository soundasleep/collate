require "json"

module JsonLoader
  def load_json_files
    languages = {}

    json_files.map do |file|
      lang = identify_language(file)
      if lang
        puts "#{file} --> #{lang}"
        languages[lang] ||= {}
        languages[lang].merge! load_json_file(file)
      end
    end

    languages.each do |lang, json|
      write_json json, lang
    end
  end

  def load_json_file(filename)
    loaded_file = File.read(filename)
    loaded_file.scrub!    # ignore invalid UTF-8 characters as necessary

    hash = JSON.load(loaded_file).to_hash.reject do |k, v|
      !k || !v
    end.map do |k, v|
      [k.strip, v.strip]
    end.reject do |k, v|
      k.empty? || v.empty?
    end.reject do |k, v|
      k.length > 300 || v.length > 300
    end.map do |k, v|
      k.gsub!(/\:([a-zA-Z_0-9]+)/, "%{\\1}")
      v.gsub!(/\:([a-zA-Z_0-9]+)/, "%{\\1}")
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
