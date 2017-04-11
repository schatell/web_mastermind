require 'sinatra'
require 'sinatra/reloader' if development?

helpers do

  def find_color(numerical_color)
    color = ["#E60000",
             "#0066FF",
             "#ffff00",
             "#009933",
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
    #Initial variables
    this_turn_feedback = []
    to_check = [true, true, true, true]
    code = session[:secret_code]
    #Check to see equal position (white pins)
    to_check.each_with_index do |check, i|
      if check
        if code[i] == guess[i]
          this_turn_feedback.push("white")
          to_check[i] = false
        end
      end
    end

    #Check for black pins
    value_to_match = []
    code.each_index do |i|
      if to_check[i]
        value_to_match << code[i]
      end
    end

    guess.each_with_index do |symbol, i|
      if to_check[i]
        this_turn_feedback.push("black") if value_to_match.include?(guess[i])
      end
    end

    #make sure that the feedback will be of length 4
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
  @color1 = find_color(params["color1"].chomp.to_i)
  @color2 = find_color(params["color2"].chomp.to_i)
  @color3 = find_color(params["color3"].chomp.to_i)
  @color4 = find_color(params["color4"].chomp.to_i)
  session[:secret_code] = [@color1, @color2, @color3, @color4]
  session[:current_turn] = 0
  session[:previous_fb] = []
  session[:previous_guess] = []
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
