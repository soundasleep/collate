Dir[File.dirname(__FILE__) + "/sources/*/load.rb"].map do |f|
  puts "[#{f}]"
  require_relative f
end
