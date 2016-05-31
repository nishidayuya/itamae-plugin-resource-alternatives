require "serverspec"
require "net/ssh"

set :backend, :ssh

options = Net::SSH::Config.for("test-server", ["spec/ssh_config"])
set :host, options[:host_name]
set :ssh_options, options
