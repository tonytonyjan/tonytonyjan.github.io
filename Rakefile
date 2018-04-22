require 'yaml'
require 'set'

desc 'Build'
task :build do
  sh 'bundle exec middleman build'
end

desc 'Deploy'
task :deploy do
  sh 'cd build && git add -A && git commit -m "$(date)" && git push'
end

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
