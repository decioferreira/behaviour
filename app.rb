require 'sinatra'
require 'sinatra/r18n'
require 'rack-flash'

require 'sequel'
require 'sqlite3'

DB = Sequel.sqlite

DB.create_table :users do
  primary_key :id
  varchar :email
  varchar :password
end

class Persistency
  include Singleton

  def add_user(user)
    DB[:users].insert(user)
  end

  def find_user(email, password)
    DB[:users].first(email: email, password: password)
  end

  def change_password(email, new_password)
    DB[:users].where(email: 'user@email.com').update(password: new_password)
  end
end

use Rack::Session::Cookie, secret: 's3cret'
use Rack::Flash

get '/' do
  erb :home
end

get '/restricted' do
  if request.cookies['signed_in']
    erb :restricted
  else
    flash[:alert] = 'Unauthenticated user.'
    redirect '/sign_in'
  end
end

get '/account/edit' do
  erb :account_edit
end

post '/account/edit' do
  if params[:current_password].empty?
    flash.now[:alert] = 'Current password required.'
  else
    flash.now[:notice] = 'Account updated successfully.'
  end

  Persistency.instance.change_password(params[:email], params[:password])
  erb :account_edit
end

get '/reset_password' do
  Mail.deliver do
    to 'decio.jferreira@gmail.com'
    from 'decio.j.ferreira@gmail.com'
    subject 'Website - password reset'
    body 'https://www.test.com/reset_password/edit?token=abcdef'
  end

  flash.now[:notice] = 'A reset password email was sent successfully.'
  erb :reset_password
end

get '/reset_password/edit' do
  erb :reset_password_edit
end

post '/reset_password/edit' do
  response.set_cookie('signed_in', value: true, path: '/')
  flash[:notice] = 'Password reset successful.'
  redirect '/'
end

get '/sign_in' do
  if request.cookies['signed_in']
    flash[:alert] = 'Already authenticated.'
    redirect '/'
  else
    erb :sign_in
  end
end

post '/sign_in' do
  if Persistency.instance.find_user(params[:email], params[:password])
    if(params[:remember_me])
      response.set_cookie('signed_in', value: true, path: '/', expires: Time.now + 3600)
    else
      response.set_cookie('signed_in', value: true, path: '/')
    end

    flash[:notice] = 'Signed in successfully.'
  elsif params[:email] != 'user@email.com'
    flash[:alert] = 'Invalid email.'
  elsif params[:password] != 'password'
    flash[:alert] = 'Invalid password.'
  end

  redirect '/'
end

get '/sign_up' do
  if request.cookies['signed_in']
    flash[:alert] = 'Already authenticated, sign out an try again.'
    redirect '/'
  else
    erb :sign_up
  end
end

post '/sign_up' do
  if Persistency.instance.find_user(params[:email], params[:password])
    flash[:alert] = 'Already registered.'
    redirect '/'
  else
    Persistency.instance.add_user(email: params[:email], password: params[:password])
    response.set_cookie('signed_in', value: true)
    flash[:notice] = 'Signed up successfully.'
    redirect '/'
  end
end

get '/sign_out' do
  response.delete_cookie('signed_in')
  flash[:notice] = 'Signed out successfully.'
  redirect '/'
end

__END__

@@ layout
<html>
  <a href="/restricted">Restricted</a>
  <a href="/sign_in">Sign in</a>
  <a href="/sign_up">Sign up</a>
  <a href="/sign_out">Sign out</a>

  <hr>

  <% if flash.has?(:alert) %>
    <div id="alert-message"><%= flash[:alert] %></div>
  <% end %>
  <% if flash.has?(:notice) %>
    <div id="notice-message"><%= flash[:notice] %></div>
  <% end %>

  <%= yield %>
</html>

@@ home
<h1>Home sweet home!</h1>

@@ restricted
<form method="get" action="/sign_out">
  <button>Sign out</button>
</form>

<h1>Restricted!</h1>

@@ account_edit
<form method="post" action="/account/edit">
  <label for="current_password">Current password</label>
  <input type="password" id="current_password" name="current_password">
  <label for="password">Password</label>
  <input type="password" id="password" name="password">
  <label for="confirm_password">Confirm password</label>
  <input type="password" id="confirm_password">

  <button>Edit</button>
</form>

@@ reset_password
<label for="email">Email</label>
<input type="text" id="email">

<button>Send</button>

@@ reset_password_edit

<form method="post" action="/reset_password/edit">
  <label for="password">Password</label>
  <input type="password" id="password">
  <label for="confirm_password">Confirm password</label>
  <input type="password" id="confirm_password">

  <button>Reset password</button>
</form>

@@ sign_in
<form method="post" action="/sign_in">
  <label for="email">Email</label>
  <input type="text" id="email" name="email">
  <label for="password">Password</label>
  <input type="password" id="password" name="password">
  <label for="remember_me">Remember me</label>
  <input type="checkbox" id="remember_me" name="remember_me">

  <input type="submit" value="Sign in">
</form>

@@ sign_up
<button>Sign out</button>

<form method="post" action="/sign_up">
  <label for="email">Email</label>
  <input type="text" id="email" name="email">
  <label for="password">Password</label>
  <input type="password" id="password" name="password">
  <label for="confirm_password">Confirm password</label>
  <input type="password" id="confirm_password">

  <button>Sign up</button>
</form>

