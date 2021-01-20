require 'minitest/autorun'
require 'minitest/pride'
require './lib/item'
require './lib/vendor'

class VendorTest < Minitest::Test
  def test_it_exists
    vendor = Vendor.new("Rocky Mountain Fresh")
    assert_instance_of Vendor, vendor
  end

  def test_vendor_attributes
    vendor = Vendor.new("Rocky Mountain Fresh")
    assert_equal "Rocky Mountain Fresh", vendor.name
    assert_equal ({}), vendor.inventory
  end

  def test_stock_is_0_by_default
    vendor = Vendor.new("Rocky Mountain Fresh")
    item1 = Item.new({name: 'Peach', price: "$0.75"})
    assert_equal 0, vendor.check_stock(item1)
  end

  def test_stock
    vendor = Vendor.new("Rocky Mountain Fresh")
    item1 = Item.new({name: 'Peach', price: "$0.75"})
    item2 = Item.new({name: 'Tomato', price: '$0.50'})
    assert_equal 0, vendor.check_stock(item1)
    vendor.stock(item1, 30)
    expected1 = {item1 => 30}
    assert_equal expected1, vendor.inventory
    vendor.stock(item1, 25)
    assert_equal 55, vendor.check_stock(item1)
    vendor.stock(item2, 12)
    expected2 = {item1 => 55, item2 => 12}
    assert_equal expected2, vendor.inventory
  end

  def test_vendor_can_find_potential_revenue
    vendor1 = Vendor.new("Rocky Mountain Fresh")
    item1 = Item.new({name: 'Peach', price: "$0.75"})
    item2 = Item.new({name: 'Tomato', price: "$0.50"})
    item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
    item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})
    vendor1.stock(item1, 35)
    vendor1.stock(item2, 7)
    assert_equal 29.75, vendor1.potential_revenue
    vendor2 = Vendor.new("Ba-Nom-a-Nom")
    vendor2.stock(item4, 50)
    vendor2.stock(item3, 25)
    assert_equal 345.00, vendor2.potential_revenue
    vendor3 = Vendor.new("Palisade Peach Shack")
    vendor3.stock(item1, 65)
    assert_equal 48.75, vendor3.potential_revenue
  end
end
