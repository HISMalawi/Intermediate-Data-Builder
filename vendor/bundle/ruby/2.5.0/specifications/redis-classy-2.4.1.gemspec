# -*- encoding: utf-8 -*-
# stub: redis-classy 2.4.1 ruby lib

Gem::Specification.new do |s|
  s.name = "redis-classy".freeze
  s.version = "2.4.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Kenn Ejima".freeze]
  s.date = "2016-12-18"
  s.description = "Class-style namespace prefixing for Redis".freeze
  s.email = ["kenn.ejima@gmail.com".freeze]
  s.homepage = "http://github.com/kenn/redis-classy".freeze
  s.rubygems_version = "3.0.8".freeze
  s.summary = "Class-style namespace prefixing for Redis".freeze

  s.installed_by_version = "3.0.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<redis-namespace>.freeze, ["~> 1.0"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_development_dependency(%q<bundler>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
    else
      s.add_dependency(%q<redis-namespace>.freeze, ["~> 1.0"])
      s.add_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_dependency(%q<bundler>.freeze, [">= 0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<redis-namespace>.freeze, ["~> 1.0"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
  end
end
