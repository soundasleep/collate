require_relative "../common"

workspace = File.dirname(__FILE__) + "/workspace"
output = File.dirname(__FILE__) + "/output"

def load_openttd_file(filename)
  pattern = /^([A-Z0-9_]+)\s+:(.+)/

  hash = File.open(filename).each_line.map(&:strip).select do |line|
    line.match pattern
  end.map do |line|
    line.match(pattern) do |match|
      [match[1], match[2]]
    end
  end.map do |k, v|
    # replace common arguments
    v.gsub! "{STRING}", ":string"
    v.gsub! "{STRING1}", ":string1"
    v.gsub! "{STRING2}", ":string2"
    v.gsub! "{NUM}", ":num"
    v.gsub! "{NUMBER}", ":number"
    v.gsub! "{VELOCITY}", ":velocity"
    [k, v]
  end.map do |k, v|
    # colours should not really be in here
    v.gsub! "{BLACK}", ""
    v.gsub! "{WHITE}", ""
    v.gsub! "{RED}", ""
    v.gsub! "{BLUE}", ""
    v.gsub! "{LTBLUE}", ""
    v.gsub! "{YELLOW}", ""
    v.gsub! "{GOLD}", ""
    [k, v]
  end.select do |k, v|
    !v.match(/\{/)
  end

  hash << ["_comment", "loaded from #{filename} by load_openttd_file"]

  Hash[hash]
end

Dir.mkdir(output) unless Dir.exists?(output)

puts "Checking out latest subversion into #{workspace}..."
passthru "svn checkout http://svn.openttd.org/trunk/src/lang/ #{workspace}"

core = load_openttd_file("#{workspace}/english.txt")
puts "Loaded #{core.keys.length} phrases in English"

# load all .txt
Dir["#{workspace}/*.txt"].map do |file|
  lang = identify_language(file)
  if lang
    puts "#{file} --> #{lang}"

    loaded = load_openttd_file(file)

    json = {}
    loaded.each do |key, value|
      if core.has_key?(key)
        english_key = core[key]
        json[english_key] = value
      else
        puts "Warning: Could not find key '#{key}' in english for #{lang}"
      end
    end

    puts "Loaded #{json.keys.count} keys for #{lang}"

    if json.any?
      outfile = "#{output}/#{lang}.json"
      File.open(outfile, "w") do |f|
        puts "Wrote file #{outfile}"
        f.write JSON.pretty_generate(json.sort.to_h)    # sorts keys
      end
    end
  end
end
