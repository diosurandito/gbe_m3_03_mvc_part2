require 'sinatra'
require './db/db_connector'

get '/' do
    items = get_all_items
    erb :index, locals: {
        items: items
    }
end

get '/items/new' do
    erb :create
end

post '/items/create' do
    name = params['name']
    price = params['price']
    create_new_item(name, price)
    redirect'/'
end

get '/items/detail/:id' do
    id = params['id']
    item = show_detail_item(id)
    erb :detail, locals: {
        item: item
    }
end

get '/items/delete/:id' do
    id = params['id']
    delete_item(id)
    redirect'/'
end

get '/items/edit/:id' do
    id = params['id']
    item = show_detail_item(id)
    categories = get_all_categories
    erb :edit, locals: {
        item: item,
        categories: categories
    }
end

post '/items/update/:id' do
    id = params['id']
    name = params['name']
    price = params['price']
    category_id = params['category_id']
    update_item(id, name, price, category_id)
    redirect'/'
end