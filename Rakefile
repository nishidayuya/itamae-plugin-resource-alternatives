require "pathname"
require "open-uri"
require "bundler/gem_tasks"
require "rspec/core/rake_task"

task spec: %i[spec:provision spec:serverspec]
task default: %i[spec build]

def run(*cmd)
  if !system(*cmd)
    raise "run failure: #{cmd.inspect}"
  end
end

namespace :spec do
  desc "Run provision"
  task :provision do
    key = URI("https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant").read
    key_path = Pathname("spec/test_server_key")
    key_path.write(key)
    key_path.chmod(0600)

    run("docker build -t test-server .")

    if `docker ps --all --no-trunc`.each_line.grep(/ test-server$/).length > 0
      run("docker rm --force test-server")
    end

    # port 22 is already used by TravisCI.
    run("docker run --name=test-server --detach --publish=10022:22 test-server")

    run("bundle exec itamae ssh --log-level=debug --ssh-config spec/ssh_config --host=test-server spec/recipe.rb")
  end

  desc "Run serverspec"
  RSpec::Core::RakeTask.new(:serverspec) do |t|
    t.ruby_opts = "-Ispec"
    t.pattern = "spec/**/*_spec.rb"
  end
end
