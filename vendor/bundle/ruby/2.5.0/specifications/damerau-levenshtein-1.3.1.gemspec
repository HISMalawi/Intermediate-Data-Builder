# -*- encoding: utf-8 -*-
# stub: damerau-levenshtein 1.3.1 ruby lib lib/damerau-levenshtein
# stub: ext/damerau_levenshtein/extconf.rb

Gem::Specification.new do |s|
  s.name = "damerau-levenshtein".freeze
  s.version = "1.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze, "lib/damerau-levenshtein".freeze]
  s.authors = ["Dmitry Mozzherin".freeze]
  s.date = "2018-02-26"
  s.description = "This gem implements pure Levenshtein algorithm, Damerau modification (where 2 character transposition counts as 1 edit distance). It also includes Boehmer & Rees 2008 modification, to handle transposition in blocks with more than 2 characters (Boehmer & Rees 2008).".freeze
  s.email = "dmozzherin@gmail.com".freeze
  s.extensions = ["ext/damerau_levenshtein/extconf.rb".freeze]
  s.files = ["ext/damerau_levenshtein/extconf.rb".freeze]
  s.homepage = "https://github.com/GlobalNamesArchitecture/damerau-levenshtein".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new("~> 2.3".freeze)
  s.rubygems_version = "3.0.8".freeze
  s.summary = "Calculation of editing distance for 2 strings using Levenshtein or Damerau-Levenshtein algorithms".freeze

  s.installed_by_version = "3.0.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.7"])
      s.add_development_dependency(%q<activesupport>.freeze, ["~> 5.1"])
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.16"])
      s.add_development_dependency(%q<byebug>.freeze, ["~> 9.0"])
      s.add_development_dependency(%q<coveralls>.freeze, ["~> 0.8"])
      s.add_development_dependency(%q<cucumber>.freeze, ["~> 3.1"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 12.3"])
      s.add_development_dependency(%q<rake-compiler>.freeze, ["~> 1.0"])
      s.add_development_dependency(%q<rubocop>.freeze, ["~> 0.52"])
      s.add_development_dependency(%q<ruby-prof>.freeze, ["~> 0.17"])
      s.add_development_dependency(%q<shoulda>.freeze, ["~> 3.5"])
    else
      s.add_dependency(%q<rspec>.freeze, ["~> 3.7"])
      s.add_dependency(%q<activesupport>.freeze, ["~> 5.1"])
      s.add_dependency(%q<bundler>.freeze, ["~> 1.16"])
      s.add_dependency(%q<byebug>.freeze, ["~> 9.0"])
      s.add_dependency(%q<coveralls>.freeze, ["~> 0.8"])
      s.add_dependency(%q<cucumber>.freeze, ["~> 3.1"])
      s.add_dependency(%q<rake>.freeze, ["~> 12.3"])
      s.add_dependency(%q<rake-compiler>.freeze, ["~> 1.0"])
      s.add_dependency(%q<rubocop>.freeze, ["~> 0.52"])
      s.add_dependency(%q<ruby-prof>.freeze, ["~> 0.17"])
      s.add_dependency(%q<shoulda>.freeze, ["~> 3.5"])
    end
  else
    s.add_dependency(%q<rspec>.freeze, ["~> 3.7"])
    s.add_dependency(%q<activesupport>.freeze, ["~> 5.1"])
    s.add_dependency(%q<bundler>.freeze, ["~> 1.16"])
    s.add_dependency(%q<byebug>.freeze, ["~> 9.0"])
    s.add_dependency(%q<coveralls>.freeze, ["~> 0.8"])
    s.add_dependency(%q<cucumber>.freeze, ["~> 3.1"])
    s.add_dependency(%q<rake>.freeze, ["~> 12.3"])
    s.add_dependency(%q<rake-compiler>.freeze, ["~> 1.0"])
    s.add_dependency(%q<rubocop>.freeze, ["~> 0.52"])
    s.add_dependency(%q<ruby-prof>.freeze, ["~> 0.17"])
    s.add_dependency(%q<shoulda>.freeze, ["~> 3.5"])
  end
end
