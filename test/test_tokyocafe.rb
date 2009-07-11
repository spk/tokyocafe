# encoding: utf-8
require 'test/unit'
$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'tokyocafe'

class MyClassTest
  include TokyoCafe::Persistable
  database 'db.tct'
  add_timestamp_for :on_create, :on_update

  attr_accessor :name

  def after_save
    puts self.inspect
    puts self.to_h.inspect
  end

  def before_delete
    puts self.to_h.inspect
  end
end

class TokyoCafeTest < Test::Unit::TestCase

  def default_test
    save_test
    get_test
    search_test
    delete_test
  end

  def save_test
    t = MyClassTest.new
    t.name = 'tokyo'
    assert t.new?
    assert t.save
    t.id
  end

  def get_test
    id = save_test
    a = MyClassTest.get(id)
    assert !a.new?
    a.name = 'tokyooo'
    assert a.save
    a.id
  end

  def delete_test
    id = get_test
    b = MyClassTest.get(id)
    assert b.delete
  end

  def search_test
    t = MyClassTest.new
    t.name = 'tokyo'
    t.save
    res = MyClassTest.search(:conditions => {:name => "tokyo"}, :limit => 3, :order => {:name => :ASC})
    assert !res.empty?
    assert (res.size < 4)
  end
end
