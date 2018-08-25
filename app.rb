#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def get_db
  db = SQLite3::Database.new 'database.db'
  db.results_as_hash = true
  return db
end 

before do
	db = get_db
	@users = db.execute 'select * from Users'
end

configure do
  db = get_db
  db.execute 'CREATE TABLE IF NOT EXISTS Users 
            	(
      			     		id integer PRIMARY KEY AUTOINCREMENT,
       			        email text,
      			        name text,
      			        lastname text
      	      )'
end

get '/' do
  erb :login
end

get '/showusers' do
    db = get_db
    @results = db.execute 'select * from Users order by id desc'
    erb :showusers
end

get '/login' do
	erb :login
end

post '/login' do
  @email = params[:email]
  @name = params[:name]
  @lastname = params[:lastname]

  hh = {  :email => 'Input email',
          :name => 'Input name',
          :lastname => 'Input lastname' }

  @error = hh.select {|key,_| params[key] == ""}.values.join(", ")
  
  if @error != ''
      return erb :login
  end

  db = get_db
  db.execute 'insert into Users
      			  (
          			  	email, 
          			    name, 
          			    lastname
      			  )
      			    values (?, ?, ?)', [@email, @name, @lastname]

  erb "<h2>Ok</h2>"
end
