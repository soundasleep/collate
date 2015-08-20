require "json"

def passthru(command)
  system(command, out: STDOUT, err: STDERR)
end

def identify_language(filename)
  bits = filename.split("/")
  bits.last[".txt"] = ""
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
