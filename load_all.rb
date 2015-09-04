Dir[File.dirname(__FILE__) + "/sources/*/load.rb"].shuffle.map do |f|
  puts "[#{f}]"
  require_relative f
end
