require 'test/unit'
$:.unshift(File.dirname(__FILE__) + "../lib")
require 'tokyocafe'

class MyClassTest
  include TokyoCafe::Persistable
  database 'db.hdb'
  add_timestamp_for :on_create, :on_update
  attr_accessor :name
end

class TokyoCafeTest < Test::Unit::TestCase
  def default_test
    t = MyClassTest.new
    t.name = 'éeee'
    p t.to_h
    assert t.new?
    assert t.save
    id = t.id
    a = MyClassTest.get(id)
    puts a.name
    assert(false, a.new?)
    a.name = 'eeeé'
    sleep 1
    assert a.save
  end
end
