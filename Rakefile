require "bundler/gem_tasks"

desc "Run test"
task :test do
  Bundler::GemHelper.install_tasks
  ruby("-rubygems", "test/run-test.rb")
end

task :default => :test
