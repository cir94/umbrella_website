require 'sinatra'
require 'sinatra/activerecord'
require 'sqlite3'
require 'rake'
require './models'

set :database, {adapter: "sqlite3", database: "umbrella.sqlite3"}

get '/' do
    erb :home
end

get '/login' do
    erb :login
end

post '/login' do
    user = User.find_by(email: params[:email])
    given_password = params[:password]
end
    
get '/signup' do
    @user = User.new(params[:user])
    erb :signup
end

post '/signup' do
    @user = User.new(params[:user])
    if @user.valid?
        @user.save
        redirect '/'
    else
        @user.errors.messages
        redirect './signup'
    end
    p params
end