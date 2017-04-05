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

  def give_fb(guess)
    this_turn_feedback = []
    skip_code = [0, 1, 2, 3]
    for y in 0..3 do
      if guess[y] == (session[:secret_code][y])
       this_turn_feedback.push("white")
       skip_code - [y]
      end
    end
    skip_code.each do | elem |
      if guess.include?(session[:secret_code][elem])
        this_turn_feedback.push("black")
      end
    end
    until this_turn_feedback.length == 4
      this_turn_feedback.push("")
    end
    session[:previous_fb].push(this_turn_feedback)
  end

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
  session[:previous_fb] = []
  session[:previous_guess] = []
  session[:victory] = false
  session[:lose] = false
  erb :play
end

post '/codebreaker' do
  guess = []
  guess.push(params["guess1"].to_i)
  guess.push(params["guess2"].to_i)
  guess.push(params["guess3"].to_i)
  guess.push(params["guess4"].to_i)
  give_fb(guess)
  colorized_guess = []
  for x in 0..3 do
    colorized_guess.push(find_color(guess[x].to_i))
  end
  session[:previous_guess].push(colorized_guess)

  #gamewon?
  session[:current_turn] += 1
  #si tour == 12 game terminer et perdu
  if session[:current_turn] == 12
    erb :play, :locals => {:session => session, :lose => true, :victory => false}
  elsif session[:victory] == true
    erb :play, :locals => {:session => session, :lose => false, :victory => true}
  else
    erb :play, :locals => {:session => session, :lose => false, :victory => false}
  end

end
