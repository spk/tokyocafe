# encoding: utf-8
require 'test/unit'
$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'tokyocafe'

class MyClassTest
  include TokyoCafe::Persistable
  database 'db.tdb'
  add_timestamp_for :on_create, :on_update
  attr_accessor :name
end

class TokyoCafeTest < Test::Unit::TestCase
  def default_test
    t = MyClassTest.new
    t.name = 'éeee'
    assert t.new?
    assert t.save
    id = t.id
    a = MyClassTest.get(id)
    assert !a.new?
    a.name = 'eeeé'
    sleep 1
    assert a.save
  end
end
