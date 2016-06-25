require "rake"
require "open3"
require "bundler/gem_tasks"
require "rspec/core/rake_task"

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
  capture("vagrant status")[/(?<=\n\n).*?(?=\n\n)/m].gsub(/ .*/, "").split("\n")
}

desc "Run Itamae and Serverspec to all"
task spec: targets.map { |target| "spec:#{target}" }
task default: %i[spec build]

namespace :spec do
  targets.each do |target|
    desc "Run Itamae and Serverspec to #{target}"
    task target.to_sym => [
      "spec:#{target}:provision",
      "spec:#{target}:serverspec",
    ]

    namespace target.to_sym do
      desc "Run Itamae to #{target}"
      task :provision do
        Bundler.with_clean_env do
          run("vagrant up #{target}")
        end
        run("itamae ssh --vagrant --host #{target} spec/recipe.rb")
      end

      desc "Run Serverspec to #{target}"
      RSpec::Core::RakeTask.new(:serverspec) do |t|
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
