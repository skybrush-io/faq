# -*- encoding: utf-8 -*-
# stub: kramdown-asciidoc 2.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "kramdown-asciidoc".freeze
  s.version = "2.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "https://github.com/asciidoctor/kramdown-asciidoc/issues", "changelog_uri" => "https://github.com/asciidoctor/kramdown-asciidoc/blob/master/CHANGELOG.adoc", "mailing_list_uri" => "http://discuss.asciidoctor.org", "source_code_uri" => "https://github.com/asciidoctor/kramdown-asciidoc" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Dan Allen".freeze]
  s.date = "2022-07-04"
  s.description = "A kramdown extension for converting Markdown documents to AsciiDoc.".freeze
  s.email = ["dan.j.allen@gmail.com".freeze]
  s.executables = ["kramdoc".freeze]
  s.files = ["bin/kramdoc".freeze]
  s.homepage = "https://github.com/asciidoctor/kramdown-asciidoc".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.3.26".freeze
  s.summary = "A Markdown to AsciiDoc converter based on kramdown".freeze

  s.installed_by_version = "3.3.26" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<kramdown>.freeze, ["~> 2.4.0"])
    s.add_runtime_dependency(%q<rexml>.freeze, ["~> 3.2.0"])
    s.add_runtime_dependency(%q<kramdown-parser-gfm>.freeze, ["~> 1.1.0"])
    s.add_development_dependency(%q<rake>.freeze, ["~> 13.0.0"])
    s.add_development_dependency(%q<rspec>.freeze, ["~> 3.11.0"])
  else
    s.add_dependency(%q<kramdown>.freeze, ["~> 2.4.0"])
    s.add_dependency(%q<rexml>.freeze, ["~> 3.2.0"])
    s.add_dependency(%q<kramdown-parser-gfm>.freeze, ["~> 1.1.0"])
    s.add_dependency(%q<rake>.freeze, ["~> 13.0.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.11.0"])
  end
end
