require_relative "po_loader"

class BaseLoader
  include PoLoader

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
      more_bits = bits.last.split("_", 2)
      lang = identify_language_string(more_bits.last)

      if !lang
        # try removing the file extension
        extension_bits = more_bits.last.split(".", 2)
        lang = identify_language_string(extension_bits.first)
      end
    end

    if !lang
      # try the parent folder name
      lang = identify_language_string(bits[-2])
    end

    if !lang
      # try the parent folder name split by "-"
      more_bits = bits[-2].split("-", 2)
      lang = identify_language_string(more_bits.last)
    end

    if !lang
      # try the parent parent folder name
      lang = identify_language_string(bits[-3])
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

    case string.sub("_", " ").downcase
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
      when "maori"
        "mi"
      when "traditional chinese", "chinese (traditional)", "zh-rtw"
        "zh_TW"
      when "simplified chinese", "chinese (simplified)", "zh-rcn"
        "zh_CN"
      when "pt-rbr"
        "pt_BR"
      else
        false
    end
  end
end
