# encoding: utf-8
require 'test/unit'
$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'tokyocafe'

class MyClassTest
  include TokyoCafe::Persistable
  database 'db.tdb'
  add_timestamp_for :on_create, :on_update
  def before_delete
    p self.to_h
  end
  attr_accessor :name
end

class TokyoCafeTest < Test::Unit::TestCase
  def default_test
    # save
    t = MyClassTest.new
    t.name = 'éeee'
    assert t.new?
    assert t.save
    id = t.id
    # get
    a = MyClassTest.get(id)
    assert !a.new?
    a.name = 'eeeé'
    sleep 1
    assert a.save
    # delete
    b = MyClassTest.get(id)
    assert b.delete
  end
end
