require './db/db_connector.rb'

class Category
    attr_accessor :id, :name
    
    def initialize(param)
        @id = param[:id]
        @name = param[:name]
    end

    def save
        return false unless valid?
        client = create_db_client
        client.query("insert into categories(name) values ('#{name}'")
    end

    def valid?
        return false if @name no.nil?
        true
    end

    def all_categories
        client = create_db_client
        rawData = client.query("select * from categories")
        categories = Array.new
        rawData.each do | data |
            category = Category.new(data["name"], data["id"])
            categories.push(category)
        end
        categories
    end
end