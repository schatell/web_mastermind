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
      if guess[y] == (session[:secret_code[y]])
       this_turn_feedback.push("W")
       guess[y] = white
       skip_code.delete(y)
      end
    end
    skip_code.each do | elem |
      if guess.include?(session[:secret_code[elem]])
        this_turn_feedback.push("B")
      end
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
  erb :play
end

post '/codebreaker' do
  guess = []
  guess.push(params["guess1"])
  guess.push(params["guess2"])
  guess.push(params["guess3"])
  guess.push(params["guess4"])
  session[:previous_guess].push(guess)
  #give_fb(guess)
  #gamewon?
  #augmenter le compteur de tour
  #si tour == 12 game terminer et perdu
  erb :play ,:locals => {:session => session}
end
