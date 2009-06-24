# encoding: utf-8
require 'test/unit'
$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
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

class TokyoCafeTest < Test::Unit::TestCase

  def default_test
    save_test
    get_test
    delete_test
  end

  def save_test
    t = MyClassTest.new
    t.name = 'éeee'
    assert t.new?
    assert t.save
    t.id
  end

  def get_test
    id = save_test
    a = MyClassTest.get(id)
    assert !a.new?
    a.name = 'eeeé'
    assert a.save
    a.id
  end

  def delete_test
    id = get_test
    b = MyClassTest.get(id)
    assert b.delete
  end
end
