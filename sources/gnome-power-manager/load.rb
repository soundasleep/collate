require "get_pomo"
require_relative "../common"

workspace = File.dirname(__FILE__) + "/workspace"
output = File.dirname(__FILE__) + "/output"

Dir.mkdir(output) unless File.exist?(output)

puts "Checking out latest Git into #{workspace}..."
if File.exist?(workspace)
  passthru "cd #{workspace} && git pull && git checkout master"
else
  passthru "git clone git@github.com:GNOME/gnome-power-manager.git #{workspace}"
end

english = {}

# load all .po
Dir["#{workspace}/po/*.po"].map do |file|
  lang = identify_language(file)
  if lang
    puts "#{file} --> #{lang}"

    json = load_po_file(file)
    puts "Loaded #{json.keys.count} keys for #{lang}"

    if json.any?
      outfile = "#{output}/#{lang}.json"
      File.open(outfile, "w") do |f|
        puts "Wrote file #{outfile}"
        f.write JSON.pretty_generate(json.sort.to_h)    # sorts keys
      end
    end

    # merge into english
    json.each do |k, v|
      english[k] = k
    end
  end
end

# write source
outfile = "#{output}/en.json"
File.open(outfile, "w") do |f|
  puts "Wrote file #{outfile}"
  f.write JSON.pretty_generate(english.sort.to_h)    # sorts keys
end
