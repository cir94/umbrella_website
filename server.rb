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
        session[:user_fullname] = [user.first_name, user.last_name].join(' ')
        session[:user_email] = user.email
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
        redirect '/login'
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
        @posts = Post.where(user_id: session[:user_id])
        puts @posts
        erb :profile
    end
end

get '/profile/:id' do
    @searchedID = params[:id]
    @user = User.find_by(id: params[:id])
    puts user.email
    erb :profile
end

get '/createpost' do
    if session[:user_id] == nil
        redirect '/login'
    elsif session[:user_deactivate] == '1'
        redirect '/deactivated'
    else
    @post = Post.new(params[:post])
    erb :createpost
    end
end

post '/createpost' do
    @post = Post.new(params[:post])
    if @post.valid?
        @post.user_id = session[:user_id]
        @post.email = session[:user_email]
        @post.time = Time.now
        @post.save
        redirect '/profile'
    else
        redirect '/'
    end
end

get '/posts' do
    @posts = Post.all
    puts @posts
    erb :posts
end

# Pages for deactivation/reactivation

# Deactivates the users account by changing flag to '1' in deactivated table in database

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

# Page deactivated accounts are redirectged to

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

# A page that serves as a reactivator, sets the flag on the deactivated table in the database to '0'

get '/reactivate' do
    user = User.find_by(id: session[:user_id])
    user.deactivated = "0"
    user.save
    session[:user_id] = nil
    session[:user_name] = nil
    erb :reactivate
end