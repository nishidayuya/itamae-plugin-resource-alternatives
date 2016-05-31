require "spec_helper"

# Manual

%w(nano vim-tiny).each do |name|
  describe package(name) do
    it { should be_installed }
  end
end

describe "alternatives resource handle manual mode" do
  describe command("update-alternatives --query editor") do
    its(:stdout) { should match /^Status: manual$/ }
    its(:stdout) { should match %r|^Value: /usr/bin/vim\.tiny$| }
  end
end

# Auto

%w(nano vim-tiny).each do |name|
  describe package(name) do
    it { should be_installed }
  end
end

describe "alternatives resource handle auto mode" do
  describe command("update-alternatives --query pager") do
    its(:stdout) { should match /^Status: auto$/ }
    its(:stdout) { should match %r|^Best: (.*?)\nValue: \1$| }
  end
end
