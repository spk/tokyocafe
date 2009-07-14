# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{tokyocafe}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["spk"]
  s.date = %q{2009-06-24}
  s.description = %q{TokyoCafe is a set of classes to help you talk
   to TokyoCabinet (http://tokyocabinet.sourceforge.net/index.html) with Ruby
   Grately inspired from http://couchobject.rubyforge.org/}
  s.email = ["spk@tuxfamily.org"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  s.files = ["History.txt", "Manifest.txt", "README.txt", "Rakefile", "lib/tokyocafe.rb", "lib/tokyocafe/persistable.rb", "lib/tokyocafe/persistable/meta_classes.rb", "lib/tokyocafe/version.rb", "test/test_tokyocafe.rb"]
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{tokyocafe}
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{TokyoCafe is a set of classes to help you talk to TokyoCabinet (http://tokyocabinet.sourceforge.net/index.html) with Ruby}
  s.test_files = ["test/test_tokyocafe.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<hoe>, [">= 2.3.0"])
    else
      s.add_dependency(%q<hoe>, [">= 2.3.0"])
    end
  else
    s.add_dependency(%q<hoe>, [">= 2.3.0"])
  end
end
