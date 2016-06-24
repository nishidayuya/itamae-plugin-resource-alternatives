# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV["VAGRANT_DEFAULT_PROVIDER"] ||= "docker"
Vagrant.configure(2) do |config|
  config.vm.provider(:docker) do |d|
    d.has_ssh = true
  end

  config.vm.define("debian") do |c|
    c.vm.provider(:docker) do |d|
      d.image = "nishidayuya/docker-vagrant-debian:jessie"
    end
  end
  config.vm.define("ubuntu") do |c|
    c.vm.provider(:docker) do |d|
      d.image = "nishidayuya/docker-vagrant-ubuntu:xenial"
    end
  end

  config.vm.provision(:shell, inline: "sudo apt-get update")
end
