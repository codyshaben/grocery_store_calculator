require 'pry'

class Item
    @@items = {}

    def initialize(name, unit_price, sale_quantity, sale_price)
        @@items[name] = {"unit_price" => unit_price, "sale_quantity" => sale_quantity, "sale_price" => sale_price}
    end

    def self.all
        @@items
    end
end


Item.new("milk", 3.97, 2, 5.00)
Item.new("bread", 2.17, 3, 6.00)
Item.new("banana", 0.99, nil, nil)
Item.new("apple", 0.89, nil, nil)