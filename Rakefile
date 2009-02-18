require 'rubygems'
require 'hoe'

$:.unshift(File.dirname(__FILE__) + "/lib")
require 'tokyocafe'

Hoe.new('tokyocafe', TokyoCafe::VERSION::STRING) do |p|
  p.name = 'tokyocafe'
  p.developer('spk', 'spk@spk-laptop')
  p.summary = <<-DESC.strip.gsub(/\n\s+/, " ")
   TokyoCafe is a set of classes to help you talk
   to TokyoCabinet (http://tokyocabinet.sourceforge.net/index.html) with Ruby
  DESC
  p.extra_deps = [
    ['json', '>= 1.1.3'],
    ['uuid', '>= 2.0.1'],
    #['libtokyocabinet-ruby', '>= 1.9'],
  ]
end
