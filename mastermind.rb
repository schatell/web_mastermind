require 'sinatra'
require 'sinatra/reloader' if development?

get '/' do
  erb :index
end

post '/codemaker' do
  erb :play
end

post '/codebreaker' do
  erb :play
end
