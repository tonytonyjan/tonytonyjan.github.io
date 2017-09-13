require 'yaml'
require 'set'

desc 'List all tags'
task :tags do
  tags = Set.new
  Dir["#{__dir__}/source/posts/*.markdown"].each do |path|
    match_data = IO.read(path).match(/---\n+(.*?)\n+---/m)
    parsed = YAML.load(match_data[1])
    tags.merge(parsed['tags']) if parsed.key?('tags')
  end
  puts tags.to_a.sort
end

desc 'List all categories'
task :categories do
  categories = Set.new
  Dir["#{__dir__}/source/posts/*.markdown"].each do |path|
    match_data = IO.read(path).match(/---\n+(.*?)\n+---/m)
    parsed = YAML.load(match_data[1])
    categories.add(parsed['category']) if parsed.key?('category')
  end
  puts categories.to_a.sort
end
