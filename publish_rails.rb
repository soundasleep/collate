# Publishes collate_rails output

require "json"
require "get_pomo"

def escape(s)
  s.inspect[1..-2]
end

output = "../collate_rails/config/locale"
Dir.mkdir(output) unless Dir.exists?(output)

# load all languages
languages = Dir[File.dirname(__FILE__) + "/sources/*/output/*.json"].map do |f|
  bits = f.split("/")
  bits.last.split(".json").first
end.uniq

puts "Found languages: #{languages}"

languages.select do |lang|
  # Rails only supports two-character languages?
  lang.length == 2
end.each do |lang|
  # Collate all JSON files
  # TODO priorities, rankings etc
  collated = {}
  count = {}

  # also load for zh = zh_TW
  Dir[File.dirname(__FILE__) + "/sources/*/output/#{lang}{,_*}.json"].each do |f|
    json = JSON.parse(File.read(f))
    collated.merge! json

    # update counts
    json.each do |k, v|
      count[k] = (count[k] || 0) + 1
    end
  end

  puts "Language #{lang}: #{collated.keys.length} keys"

  # only select keys that have more than two instances
  collated = collated.select do |k, v|
    count[k] >= 2
  end

  puts " --> #{collated.keys.length} keys used more than once"

  output_lang = "#{output}/#{lang}"
  Dir.mkdir(output_lang) unless Dir.exists?(output_lang)

  outfile = "#{output_lang}/app.po"

  File.open(outfile, "w") do |f|
    translations = collated.sort.map do |k, v|
      t = GetPomo::Translation.new
      # fix GetPomo implementation
      t.msgid = k.gsub("\n", "\\n")
      t.msgstr = v.gsub("\n", "\\n")
      t
    end
    puts "Wrote file #{outfile}"
    f.write GetPomo::PoFile.to_text(translations)
  end

end
