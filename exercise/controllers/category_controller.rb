require 'erb'
require './models/category.rb'

class CategoryController

    def create_category(params)
        category = Category.new({
            name: params['name']
        })
        category.save
        renderer = ERB.new(File.read("./views/category.erb"))
        renderer.result(binding)
    end

end