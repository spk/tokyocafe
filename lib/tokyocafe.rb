$KCODE = 'u'
require 'jcode'
require 'rubygems'

gem 'json'
begin
  require 'json/ext'
rescue LoadError
  $stderr.puts 'C version of json (fjson) could not be loaded, using pure ruby'
  require 'json/pure'
end
require 'json/add/core'

require 'kconv' # To convert all input to UTF-8 before it is made to_json

require 'tokyocabinet'

require 'tokyocafe/utils'
require 'tokyocafe/persistable'
require 'tokyocafe/version'

module TokyoCafe
end
