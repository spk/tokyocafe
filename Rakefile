require 'rake/testtask'
require 'rake/packagetask'
require 'rake/rdoctask'
require 'rake'
require 'find'

# Globals

PKG_NAME = 'tokyocafe'
PKG_VERSION = '0.0.2'

PKG_FILES = ['README.rdoc', 'Rakefile']
Find.find('lib/') do |f|
  if FileTest.directory?(f) and f =~ /\.svn|\.git/
    Find.prune
  else
    PKG_FILES << f
  end
end

# Tasks

task :default => [:clean, :repackage]

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/test_*.rb']
end

Rake::RDocTask.new do |rd|
  f = []
  require 'find'
  Find.find('lib/') do |file|
    # Skip hidden files (.svn/ directories and Vim swapfiles)
    if file.split(/\//).last =~ /^\./
      Find.prune
    else
      f << file if not FileTest.directory?(file)
    end
  end
  rd.rdoc_files.include(f)
  rd.options << '--all'
end

Rake::PackageTask.new(PKG_NAME, PKG_VERSION) do |p|
  p.need_tar = true
  p.package_files = PKG_FILES
end

# "Gem" part of the Rakefile
require 'rake/gempackagetask'

spec = Gem::Specification.new do |s|
  s.author = 'spk'
  s.email = 'spk@tuxfamily.org'
  s.platform = Gem::Platform::RUBY
  s.homepage = 'http://github.com/spk/tokyocafe'
  s.summary = <<-DESC.strip.gsub(/\n\s+/, " ")
   TokyoCafe is a set of classes to help you talk to TokyoCabinet
  DESC
  s.name = PKG_NAME
  s.version = PKG_VERSION
  s.requirements << 'libtokyocabinet-ruby'
  s.require_path = 'lib'
  s.files = PKG_FILES
  s.description = <<-DESC.strip.gsub(/\n\s+/, " ")
   TokyoCafe is a set of classes to help you talk
   to TokyoCabinet (http://1978th.net/tokyocabinet/) with Ruby
  DESC
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end
