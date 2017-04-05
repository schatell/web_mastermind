require 'sinatra'
require 'sinatra/reloader' if development?

helpers do

  def find_color(numerical_color)
    color = ["#E60000",
             "#0066FF",
             "#ffff00",
             "#66FF33",
             "#993366",
             "#00ffcc"]
    return color[numerical_color]
  end

  def create_code
    code = []
    4.times do
      code.push(rand(0..5))
    end
    return code
  end

  # def give_fb
  #  white = 0
  #  black = 0
  #  y = 0
  #  z = 0
  #  guess_arr = []
  #  skip_code = [0, 1, 2, 3]
  #  for x in 0..3 do
  #    guess_arr.push("o".colorize(guess[x].to_sym))
  #  end
  #  for y in 0..3 do
  #    if guess_arr[y] == @code[y]
  #      white += 1
  #      guess_arr[y] = white
  #      skip_code.delete(y)
  #    end
  #  end
  #  skip_code.each do | elem |
  #    if guess_arr.include?@code[elem]
  #      black += 1
  #    end
  #  end
#  end

end

enable :sessions

get '/' do
  erb :index
end

get '/codemaker' do
  :session
  @color1 = find_color(params["color1"].chomp.to_i)
  @color2 = find_color(params["color2"].chomp.to_i)
  @color3 = find_color(params["color3"].chomp.to_i)
  @color4 = find_color(params["color4"].chomp.to_i)
  erb :play
end

get '/codebreaker' do
  session[:secret_code] = create_code
  session[:current_turn] = 0
  erb :play
end

post '/codebreaker' do
  erb :play
  #Receive the code
  #Store the code in an array
  #give_fb(#codearray)
  #gamewon?
  #augmenter le compteur de tour
  #si tour == 12 game terminer et perdu
end
