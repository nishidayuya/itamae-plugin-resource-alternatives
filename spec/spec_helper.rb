require "tempfile"
require "open3"

require "serverspec"
require "net/ssh"

def run(*args)
  Bundler.with_clean_env do
    stdout, status = *Open3.capture2(*args)
    if !status.success?
      raise "failure: #{args.inspect}"
    end
    return stdout
  end
end

host = ENV["TARGET_HOST"]
run("vagrant up #{host}")
options = Tempfile.open("") do |f|
  f.write(run("vagrant ssh-config #{host}"))
  f.close
  Net::SSH::Config.for(host, [f.path])
end

set :backend, :ssh
set :host, options[:host_name] || host
set :ssh_options, options
