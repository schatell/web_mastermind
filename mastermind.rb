require 'sinatra'
require 'sinatra/reloader' if development?

get '/' do
  erb :index
end

post '/codemaker' do
  @player_type = "CodeMaker"
  erb :play
end

post '/codebreaker' do
  @player_type = "Codebreaker"
  erb :play
end
