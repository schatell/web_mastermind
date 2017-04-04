require 'sinatra'
require 'sinatra/reloader' if development?

enable :session

get '/' do
  erb :index
end

get '/codemaker' do
  @color1 = find_color(params["color1"].chomp.to_i)
  @color2 = find_color(params["color2"].chomp.to_i)
  @color3 = find_color(params["color3"].chomp.to_i)
  @color4 = find_color(params["color4"].chomp.to_i)
  erb :play
end

get '/codebreaker' do
  erb :play
end

def find_color(numerical_color)
  color = ["#E60000",
           "#0066FF",
           "#ffff00",
           "#66FF33",
           "#993366",
           "#00ffcc"]
  return color[numerical_color]
end
