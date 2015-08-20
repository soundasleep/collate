require "json"

def passthru(command)
  system(command, out: STDOUT, err: STDERR)
end

def identify_language(filename)
  bits = filename.split("/")
  bits.last.gsub! /\.([a-z]{2,3})$/, ""

  return bits.last if bits.last.match(/^[a-z]{2}$/) || bits.last.match(/^[a-z]{2}_[A-Z]{2}$/)

  case bits.last
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
      puts "Could not identify language #{filename}"
      false
  end
end

def load_po_file(filename)
  hash = GetPomo::PoFile.parse(File.read(filename)).map do |translation|
    if translation.plural?
      [ [translation.msgid[0], translation.msgstr[0]],
        [translation.msgid[1], translation.msgstr[1]] ]
    else
      [[ translation.msgid, translation.msgstr ]]
    end
  end.flatten(1).reject do |k, v|
    !k || !v || k.empty? || v.empty?
  end

  hash << ["_comment", "loaded from #{filename} by load_po_file"]

  Hash[hash]
end
