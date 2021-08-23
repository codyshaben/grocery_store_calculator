require 'terminal-table'

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
                    abort "At least one of your items is not available, please enter valid items only."
                end
            end
        end
        GroceryCart.new(grocery_list)
        GroceryCart.count_items
    end
end

class Checkout
    def print_reciept
        calculate_reciept
        @table = Terminal::Table.new :headings => ['Item', 'Quantity' ,'Price', ], :rows => @rows, :style => {:width => 40}
        puts ""
        puts @table
        puts ""
        puts "Total price : $" + '%.2f' % @cart_total
        puts "You saved $" + '%.2f' % @savings + " today."
    end

    private

    def calculate_reciept
        @rows = []
        @cart_total = 0.00
        @savings = 0.00
        @grocery_cart = GroceryCart.count_items
        @grocery_cart.keys.each do |key, value|
            @item_count = @grocery_cart[key]
            @sale_quantity = Item.all[key]["sale_quantity"]
            @sale_price = Item.all[key]["sale_price"]
            @unit_price = Item.all[key]["unit_price"]
            @item_total = 0.00
            if !@sale_price
                @item_total += (@item_count * @unit_price)
            elsif !!@sale_price
                case 
                when @item_count < @sale_quantity
                    @item_total += @item_count * @unit_price
                when @item_count >= @sale_quantity
                    @item_total += (@item_count / @sale_quantity) * @sale_price
                    @item_total += (@item_count % @sale_quantity) * @unit_price
                    @savings += (@item_count * @unit_price) - @item_total
                else 
                    puts "Error, please try again"
                end
            else
                puts "Error, please try again"
            end
            @rows << [key.capitalize(), @grocery_cart[key], "$" + '%.2f' % @item_total]
            @cart_total += @item_total
        end
    end
end

Item.new("milk", 3.97, 2, 5.00)
Item.new("bread", 2.17, 3, 6.00)
Item.new("banana", 0.99, nil, nil)
Item.new("apple", 0.89, nil, nil)

new_customer = AddToCart.new()
new_customer.add_items

checkout = Checkout.new()
checkout.print_reciept