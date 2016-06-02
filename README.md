# Itamae::Plugin::Resource::Alternatives

Itamae resource plugin to manage "update-alternatives".

[![License X11](https://img.shields.io/badge/license-X11-brightgreen.svg)](https://raw.githubusercontent.com/nishidayuya/itamae-plugin-resource-alternatives/master/LICENSE.txt)

## Installation

Add this line to your application's Gemfile:

```ruby
gem "itamae-plugin-resource-alternatives"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install itamae-plugin-resource-alternatives

## Usage

```ruby
# set "editor" to "/usr/bin/vim.tiny"
alternatives "editor" do
  path "/usr/bin/vim.tiny"
end

# set "pager" to automatic mode
alternatives "pager" do
  auto true
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nishidayuya/itamae-plugin-resource-alternatives
