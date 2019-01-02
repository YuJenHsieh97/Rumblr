require 'sinatra'
require "sinatra/reloader"

# Run this script with `bundle exec ruby app.rb`

require 'active_record'

#require classes
# require './models/cake.rb'
require './models/user.rb'
require './models/post.rb'


# Use `binding.pry` anywhere in this script for easy debugging
require 'pry'

# Connect to a sqlite3 database
# If you feel like you need to reset it, simply delete the file sqlite makes

if ENV['DATABASE_URL']
  ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
else
  ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/carson.db'
)
end

register Sinatra::Reloader
enable :sessions

get '/' do
  erb :login
end

get'/login' do
  erb :login
end

post '/users/login' do
  user = User.find_by(email: params['email'], password: params['password'])
  session[:user_id] = user.id
  @post = Post.all
  @user = user
  if user
    erb :feed
  else
    erb :signup
  end
end

get '/feed' do
  # @user = User.find(session[:user_id])
  # @post = Post.all
  erb :feed
end

get '/post' do
  @post = Post.all
  erb :post
end

post '/posts' do
  Post.create(user_id: session[:user_id], text: params["text"], image: params['link'])
  @post = Post.all
  erb :feed
end

get'/account' do
  @user = User.find(session[:user_id])
  @post = Post.all
  erb :account
end

get '/account/delete/:id' do
    user_id = params[:id]
    user = User.find_by_id(user_id)
    user.posts.destroy_all
    User.find(session[:user_id]).destroy
    session[:user_id] = nil
    redirect '/login'
end

get '/post/delete/:id' do 
    Post.find(params[:id]).destroy
    redirect '/feed'
end

get '/signup' do
  erb :signup
end

post '/users/signup' do
  temp_user = User.find_by(email: params['email'])
  if temp_user
    redirect '/login'
  else
    user = User.create(firstName: params['firstName'], lastName: params['lastName'], email: params['email'], password: params['password'], pic: params['pic'])
    # session[:user_id] = user_id
    redirect '/'
  end
end

get '/logout' do
  session[:user_id] = nil
  redirect '/login'
end
