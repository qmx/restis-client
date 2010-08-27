begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "restis-client"
    gemspec.summary = "client for messaging over redis"
    gemspec.description = "durable topic subscriber implementation"
    gemspec.email = "douglas@theros.info"
    gemspec.homepage = "http://github.com/qmx/restis-client"
    gemspec.authors = ["Douglas Campos", "Gustavo Santana"]
    ["redis"].each do |dep|
      gemspec.add_dependency(dep)
    end
  end
	Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end
