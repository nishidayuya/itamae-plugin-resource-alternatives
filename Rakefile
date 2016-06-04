require "pathname"
require "open-uri"
require "open3"
require "bundler/gem_tasks"
require "rspec/core/rake_task"

task spec: %i[spec:provision spec:serverspec]
task default: %i[spec build]

def run(*cmd)
  if !system(*cmd)
    raise "run failure: #{cmd.inspect}"
  end
end

def run_and_stdout(*cmd)
  stdout, status = *Open3.capture2(*cmd)
  if !status.success?
    raise "run failure: #{cmd.inspect}"
  end
  return stdout
end

def container_port(container_name)
  return run_and_stdout(*%W"docker inspect",
                        "--format={{range $p, $conf := .NetworkSettings.Ports}}{{(index $conf 0).HostPort}}{{end}}",
                        container_name)
end

namespace :spec do
  desc "Run provision"
  task :provision do
    key = URI("https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant").read
    key_path = Pathname("spec/test_server_key")
    key_path.write(key)
    key_path.chmod(0600)

    run("docker build -t test-server .")

    path = Pathname("spec/.last_ran_container")
    if path.exist?
      run(*%W"docker rm -f", path.read.chomp)
    end

    container_name = "test-server-#{Time.now.strftime('%Y%m%d-%H%M%S')}"
    path.write(container_name)
    run(*%W"docker run --name=#{container_name} --detach --publish-all
              test-server")
    port = container_port(container_name)
    File.write("spec/ssh_config",
               File.read("spec/ssh_config.in") % {port: port})
    run(*%W"bundle exec itamae ssh --log-level=debug
              --ssh-config spec/ssh_config
              --host=test-server
              --port=#{port}
              spec/recipe.rb")
  end

  desc "Run serverspec"
  RSpec::Core::RakeTask.new(:serverspec) do |t|
    t.ruby_opts = "-Ispec"
    t.pattern = "spec/**/*_spec.rb"
  end
end
