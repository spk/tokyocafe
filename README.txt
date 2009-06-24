= tokyocafe

* http://gitorious.org/tokyocafe
* http://github.com/spk/tokyocafe/tree/master

== DESCRIPTION:

   TokyoCafe is a set of classes to help you talk
   to TokyoCabinet (http://tokyocabinet.sourceforge.net/index.html) with Ruby
   Grately inspired from http://couchobject.rubyforge.org/

== FEATURES/PROBLEMS:

* FIX (list of features or problems)

== SYNOPSIS:

require 'tokyocafe'

class MyClassTest
  include TokyoCafe::Persistable
  database 'db.tdb'
  add_timestamp_for :on_create, :on_update

  attr_accessor :name

  def before_delete
    puts self.to_h.inspect
  end
end

# See test/test_tokyocafe.rb for more info

== REQUIREMENTS:

    ['libtokyocabinet-ruby', '>= 1.21']

== INSTALL:

sudo gem install tokyocafe

== LICENSE:

(The MIT License)

Copyright (c) 2009 spk

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
