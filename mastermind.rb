require 'sinatra'
require 'sinatra/reloader' if development?

get '/' do
  erb :index
end

get '/codemaker' do
  @player_type = "CodeMaker"
  erb :play
end

get '/codebreaker' do
  @player_type = "Codebreaker"
  erb :play
end
