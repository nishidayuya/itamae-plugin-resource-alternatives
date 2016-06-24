require "rake"
require "open3"
require "bundler/gem_tasks"
require "rspec/core/rake_task"

task spec: %i[spec:provision spec:serverspec]
task default: %i[spec build]

def run(*args)
  if !system(*args)
    raise "failure: #{args.inspect}"
  end
end

def capture(*args)
  stdout, status = *Open3.capture2(*args)
  if !status.success?
    raise "failure: #{args.inspect}"
  end
  return stdout
end

targets = Bundler.with_clean_env {
  `vagrant status`[/(?<=\n\n).*?(?=\n\n)/m].gsub(/ .*/, "").split("\n")
}

namespace :spec do
  desc "Run Itamae to all"
  task provision: targets.map { |target| "spec:provision:#{target}" }

  namespace :provision do
    targets.each do |target|
      desc "Run Itamae to #{target}"
      task target.to_sym do
        Bundler.with_clean_env do
          run("vagrant up #{target}")
        end
        run("itamae ssh --vagrant --host #{target} spec/recipe.rb")
      end
    end
  end

  desc "Run Serverspec to all"
  task serverspec: targets.map { |target| "spec:serverspec:#{target}" }

  namespace :serverspec do
    targets.each do |target|
      desc "Run Serverspec to #{target}"
      RSpec::Core::RakeTask.new(target.to_sym) do |t|
        ENV["TARGET_HOST"] = target
        t.pattern = "spec/*_spec.rb"
      end
    end
  end
end

task :clean do
  Bundler.with_clean_env do
    run("vagrant destroy -f")
  end
end
