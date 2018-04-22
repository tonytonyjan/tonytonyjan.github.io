# frozen_string_literal: true

require 'bundler/setup'
require 'benchmark'
require 'fileutils'
require 'active_support'
require_relative 'autoloader'

n = 10000
words = (?a..?z).to_a.permutation(5).lazy.map(&:join).first(n)
class_names = words.map(&:capitalize)
FileUtils.rm_rf %w[as al]
FileUtils.mkdir_p 'as/foo'
FileUtils.mkdir_p 'al/bar'
words.each do |word|
  IO.write "as/foo/#{word}.rb", "module Foo; module #{word.capitalize} end end"
  IO.write "al/bar/#{word}.rb", "module Bar; module #{word.capitalize} end end"
end

Benchmark.bm(13) do |x|
  ActiveSupport::Dependencies.autoload_paths = ['as']
  x.report('ActiveSupport') do
    class_names.each do |class_name|
      eval "Foo::#{class_name}"
    end
  end

  IO.write 'al/bar.rb', 'module Bar; include Autoloader end'
  require_relative 'al/bar'
  x.report('Autoloader') do
    class_names.each do |class_name|
      eval "Bar::#{class_name}"
    end
  end
end
