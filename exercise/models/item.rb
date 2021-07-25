require './db/db_connector.rb'

class Item 
    attr_accessor :name, :price, :id, :category

    def initialize(name, price, id, category = nil)
        @name = name
        @price = price
        @id = id
        @category = []
    end

    def get_all_items
        client = create_db_client
        rawData = client.query("select * from items")
        items = Array.new
    
        rawData.each do |data|
            item = Item.new(data["name"], data["price"], data["id"])
            items.push(item)
        end
        items
    end
    
    def get_all_item_with_categories
        client = create_db_client
        rawData = client.query("select items.id, items.name, categories.name as category_name, categories.id as category_id from items
        join item_categories on items.id = item_categories.item_id
        join categories on item_categories.category_id = categories.id
        ")
        items = Array.new
    
        rawData.each do | data |
            category = Category.new(data["category_name"], data["category_id"])
            item = Item.new(data["name"], data["price"], data["id"], category)
            items.push(item)
        end
    
        items
    end
    
    def create_new_item(name, price)
        client = create_db_client
        client.query("insert into items (name, price) values ('#{name}', '#{price}')")
    end
    
    # show detail
    def show_detail_item(id)
        client = create_db_client
        rawData = client.query("select items.*, categories.name as category_name, categories.id as category_id from items
        left join item_categories on items.id = item_categories.item_id
        left join categories on item_categories.category_id = categories.id
        where items.id = '#{id}'")
        items = Array.new
    
        rawData.each do | data |
            if data["category_name"] != nil
                category = Category.new(data["category_name"], data["category_id"])
            else
                category = Category.new("Uncategorized", 0)
            end
            item = Item.new(data["name"], data["price"], data["id"], category)
            items.push(item)
        end
        item = items[0]
    end
    
    # Delete Item
    def delete_item(id)
        client = create_db_client
        client.query("delete from items where id = '#{id}'")
        i_c = client.query("select count(item_id) as c_id from item_categories where item_id = '#{id}'")
        h = nil
        i_c.each do |i|
            hasil = i["c_id"]
            h = hasil
        end
        if h != 0
            client.query("delete from item_categories where item_id = '#{id}'")
        end
    end
    
    # Update Item
    def update_item(id, name, price, category_id)
        client = create_db_client
        client.query("update items 
        set name = '#{name}', price = '#{price}' 
        where id = '#{id}'")
        i_c = client.query("select count(item_id) as c_id from item_categories where item_id = '#{id}'")
        h = nil
        i_c.each do |i|
            hasil = i["c_id"]
            h = hasil
        end
        if h == 0
            client.query("insert into item_categories (item_id, category_id) values ('#{id}', '#{category_id}')")
            
        else
            client.query("update item_categories
            set category_id = '#{category_id}'
            where item_id = '#{id}'")
        end
        
    end
end