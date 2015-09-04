require "yaml"

module YamlLoader

  def load_yaml_files
    english = {}
    languages = {}

    yaml_files.map do |file|
      lang = identify_language(file)
      if lang
        puts "#{file} --> #{lang}"

        english_yaml ||= load_english_yaml_file(file)

        languages[lang] ||= {}
        languages[lang].merge! load_yaml_file(file, english_yaml)
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

  def load_english_yaml_file(filename)
    YAML::load(File.open(english_yaml_file_for(filename)))
  end

  def english_yaml_file_for(filename)
    File.dirname(filename) + "/en.yml"
  end

  def iterate_yaml(keys, source)
    source.map do |k, value|
      if value.is_a?(Hash) || value.is_a?(Array)
        if !keys[k]
          puts "Could not find key #{k} from en.yml"
          nil
        else
          iterate_yaml(keys[k], value)
        end
      else
        [[ keys[k], value ]]
      end
    end.flatten(1)
  end

  def load_yaml_file(filename, english_yaml)
    loaded_file = File.read(filename)
    loaded_file.scrub!    # ignore invalid UTF-8 characters as necessary

    yaml = YAML::load(loaded_file)

    iterated = iterate_yaml(english_yaml[english_yaml.keys.first], yaml[yaml.keys.first])

    hash = iterated.reject do |k, v|
      !k || !v
    end.map do |k, v|
      [k.strip, v.strip]
    end.reject do |k, v|
      k.empty? || v.empty?
    end.reject do |k, v|
      k.length > 300 || v.length > 300
    end.reject do |k, v|
      k.match(/\%[^{]/) || v.match(/\%[^{]/)
    end.reject do |k, v|
      k.match("--") || v.match("--")
    end.reject do |k, v|
      k.match(/<.+>/) || v.match(/<.+>/)    # strip anything with HTML
    end.map do |k, v|
      [k.strip, v.strip]
    end.reject do |k, v|
      k.empty? || v.empty?
    end

    hash << ["_comment", "loaded from #{filename} by load_ts_file"]

    Hash[hash]
  end

end
