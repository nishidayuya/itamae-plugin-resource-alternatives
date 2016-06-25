require "rake"
require "bundler/gem_tasks"
require "rspec/core/rake_task"

task spec: %i[spec:provision spec:serverspec]
task default: %i[spec build]

def run(*args)
  if !system(*args)
    raise "failure: #{args.inspect}"
  end
end

namespace :spec do
  desc "Run Itamae to test server"
  task :provision do
    Bundler.with_clean_env do
      run("vagrant up")
    end
    run("itamae ssh --vagrant --host default spec/recipe.rb")
  end

  desc "Run Serverspec to test server"
  RSpec::Core::RakeTask.new(:serverspec) do |t|
    ENV["TARGET_HOST"] = "default"
    t.pattern = "spec/*_spec.rb"
  end
end

task :clean do
  Bundler.with_clean_env do
    run("vagrant destroy -f")
  end
end
