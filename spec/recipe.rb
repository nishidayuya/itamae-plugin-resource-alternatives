if ENV["CODECLIMATE_REPO_TOKEN"]
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

# Manual

%w(nano vim-tiny).each do |name|
  package name
end

alternatives "editor" do
  path "/usr/bin/vim.tiny"
end

# Auto

%w(less lv).each do |name|
  package name
end

execute "update-alternatives --set pager /bin/less"

alternatives "pager" do
  auto true
end
