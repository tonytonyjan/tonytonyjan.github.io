module Autoloader
  def self.included(mod)
    caller_path, = caller(1..1).first.partition(':')
    pattern = "#{File.dirname(caller_path)}/#{File.basename(caller_path, '.rb')}/*.rb"
    Dir.glob(pattern).each do |path|
      class_name = File.basename(path, '.rb').split('_').map(&:capitalize).join.to_sym
      mod.autoload class_name, path
    end
  end
end
