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

class GroceryCart
    def initialize(items)
        @@items = items
    end

    def self.count_items
        @@current_cart = Hash.new(0)
        @@items.each { |name| @@current_cart[name] += 1 } 
        @@current_cart
    end
end

class AddToCart
    def add_items
        add_to_cart
    end

    private

    def add_to_cart
        puts "Please enter all the items purchased seperated by a comma"
        grocery_list = gets.chomp.downcase.split(',').map(&:strip)
        grocery_items_available = Item.all.keys

        if grocery_list.empty?
            abort "There are no items in your cart, please add items to checkout"
        else
            grocery_list.map do |item|
                if !grocery_items_available.include?(item)
                    abort "At least one of your items is not available, please re-enter with valid items"
                end
            end
        end
        GroceryCart.new(grocery_list)
        GroceryCart.count_items
    end
end

Item.new("milk", 3.97, 2, 5.00)
Item.new("bread", 2.17, 3, 6.00)
Item.new("banana", 0.99, nil, nil)
Item.new("apple", 0.89, nil, nil)

