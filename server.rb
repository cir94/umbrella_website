require 'sinatra'
require 'sinatra/activerecord'
require 'sqlite3'
require 'rake'
require './models'

set :database, {adapter: "sqlite3", database: "umbrella.sqlite3"}
enable :sessions

get '/' do
    erb :home
end

get '/login' do
    erb :login
end

post '/login' do
    user = User.find_by(email: params[:email])
    given_password = params[:password]
    if user.password == given_password
        session[:user_id] = user.id
        session[:user_name] = [user.first_name, user.last_name].join(' ')
        puts "You've been signed in"
        redirect './profile'
    else
    puts "Incorrect credentials. Please check your e-mail and password."
        redirect './login'
    end
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

get '/logout' do
    session[:user_id] = nil
    redirect '/'
end

get '/profile' do
    erb :profile
end