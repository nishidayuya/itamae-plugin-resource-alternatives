require "itamae"

module Itamae::Plugin
end

module Itamae::Plugin::Resource
end

class Itamae::Plugin::Resource::Alternatives < Itamae::Resource::Base
  class Error < StandardError
  end

  define_attribute :action, default: :create
  define_attribute :name, type: String, default_name: true
  define_attribute :path, type: String, default: nil
  define_attribute :auto, type: [TrueClass, FalseClass], default: false

  def set_current_attributes
    q = run_command(["update-alternatives", "--query", attributes.name])
    parse_query(q)
  end

  def action_create(_options)
    if attributes.auto
      if !current.auto
        run_command(["update-alternatives", "--auto", attributes.name])
      end
    else
      if current.auto || attributes.path != current.path
        run_command([
                      "update-alternatives", "--set", attributes.name,
                      attributes.path,
                    ])
      end
    end
  end

  private

  def parse_query(q)
    generic_name_entry = parse_entry(q.stdout[/.*?(?=\n\n)/m])
    case generic_name_entry[:status]
    when "manual"
      current.auto = false
    when "auto"
      current.auto = true
    else
      raise Error, "malformed status: #{generic_name_entry[:status].inspect}"
    end
    if !current.auto
      current.path = generic_name_entry[:value]
    end
  end

  def parse_entry(entry)
    last_key = nil
    return entry.each_line.each_with_object({}) do |l, h|
      case l.chomp
      when /: /
        key = $`.downcase.to_sym
        value = $'
        h[key] = value
        last_key = key
      when /:\z/
        last_key = $`.downcase.to_sym
      when /\A /
        h[last_key] ||= []
        h[last_key] << $'
      else
        raise Error, "malformed line: '#{l.inspect}'"
      end
    end
  end
end
