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
        session[:user_deactivate] = user.deactivated
        puts "You've been signed in"
        redirect './profile'
    elsif session[:user_deactivate] = 1
        redirect './deactivated'
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
    session[:user_name] = nil
    redirect '/'
end

get '/profile' do
    if session[:user_id] == nil
        redirect '/login'
    elsif session[:user_deactivate] == '1'
        redirect '/deactivated'
    else
        erb :profile
    end
end

get '/deactivation' do
    if session[:user_id] == nil
        redirect '/login'
    else
        user = User.find_by(id: session[:user_id])
        session[:user_deactivate] = user.deactivated
        erb :deactivation
    end
end

get '/deactivate' do
    user = User.find_by(id: session[:user_id])
    user.deactivated = "1"
    user.save
    session[:user_id] = nil
    session[:user_name] = nil
    erb :deactivate
end

get '/deactivated' do
    puts session[:user_deactivate]
   if session[:user_id] == nil
        redirect '/login'
   elsif session[:user_deactivate] == '0'
        redirect '/profile'
   else
        erb :deactivated
   end
end

get '/reactivate' do
    user = User.find_by(id: session[:user_id])
    user.deactivated = "0"
    user.save
    session[:user_id] = nil
    session[:user_name] = nil
    erb :reactivate
end