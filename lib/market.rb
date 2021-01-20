require 'date'

class Market
  attr_reader :name,
              :vendors,
              :date

  def initialize(name)
    @name = name
    @vendors = []
    @date = Time.now.strftime("%m%d%Y")
  end

  def sell(item, amount)
    item_amount = total_inventory[item][:quantity]
    if item_amount > amount
      true
    else
      false
    end
  end

  def add_vendor(vendor)
    @vendors.push(vendor)
  end

  def vendor_names
    @vendors.map do |vendor|
      vendor.name
    end
  end

  def vendors_that_sell(item)
    @vendors.find_all do |vendor|
      vendor.inventory.include?(item)
    end
  end

  def sorted_item_list
    @vendors.flat_map do |vendor|
      vendor.inventory.map do |item, quantity|
        item.name
      end
    end.sort.uniq
  end

  def overstocked_items
    new = []
    @vendors.each do |vendor|
      new = vendor.inventory.find_all do |item, quantity|
        vendor.check_stock(item) > 50
    end.flatten
    end
    [new.shift]
  end

  def total_inventory
    inventory = {}
    @vendors.each do |vendor|
      vendor.inventory.each do |item, amount|
      inventory[item] ||= {quantity: 0, vendors: []}
        inventory[item][:quantity] += amount
        inventory[item][:vendors] = vendors_that_sell(item)
      end
    end
    inventory
  end
end
