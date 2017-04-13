require 'sinatra'
require 'sinatra/reloader' if development?

helpers do

  def ai_game_loop
    create_possible_list
    make_list
    for x in 0..11 do
      choose_guess(x)
      colorized_guess = []
      for x in 0..3 do
        colorized_guess.push(find_color(@guess[x].to_i))
      end
      session[:previous_guess].push(colorized_guess)
      give_fb(@guess)
      if check_victory
        session[:aiwon] = true
        break
      end
      react_to_fb
    end
    session[:ailost] = true
  end

  def create_possible_list
    @possible = [0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 4, 4, 4, 4, 4, 5,
      5, 5, 5]
    @possible_solution = Array.new
    @possible_score = {}
  end

  def make_list
    @possible_solution = @possible.combination(4).to_a
  end

  def choose_guess(x)
    @guess = []
    if x == 0
      @best_available_guess = []
      @guess = [0, 0, 1, 1]
    else
      @guess = @next_guess
    end
  end

  def react_to_fb
    delete_old_guess
    analyse_fb
    delete_irrelevant_guess(@max_possible_point)
    calculate_point_system(@guess)
    order_by_best
  end

  def delete_old_guess
    @possible_solution.delete(@guess)
  end

  def analyse_fb
    @max_possible_point = 0
    session[:previous_fb][-1].each do |elem|
      if elem == "white"
        @max_possible_point += 2
      end
      if  elem == "black"
        @max_possible_point += 1
      end
    end
  end

  def delete_irrelevant_guess(fb_pts)
    pos_to_delete =[]
    if fb_pts == 0
      @possible_solution.each_with_index do |elem, index|
        for x in 0..3 do
          if elem.include?(@guess[x])
            pos_to_delete.push[index]
          end
        end
      end
    end
    pos_to_delete.each do |ind|
      @possible_solution.delete_at(ind)
    end
  end

  def calculate_point_system(guess)
    @best_available_guess = {}
    @possible_solution.each do |elem|
      maxpoint = @max_possible_point
      elempoint = 0
      for x in 0..3 do
        if @guess[x] == elem[x]
          maxpoint -= 2
          elempoint += 2
        end
        if elem.include?(@guess[x])
          maxpoint -= 1
          elempoint += 1
        end
        break if maxpoint == 0
      end
      @best_available_guess[elempoint] = elem
    end
  end

  def order_by_best
    @next_guess = []
    x = 0
    y = 0
    @best_available_guess.each do |points, guess|
      y = points
      if y > x
        @next_guess = guess
        x = points
      end
    end
  end

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
    guess_to_check = [true, true, true, true]
    code_to_check = [true, true, true, true]
    code = session[:secret_code]

    #Check to see equal position(white pins)
    guess_to_check.each_with_index do |check, i|
      if check
        if code[i] == guess[i]
          this_turn_feedback.push("white")
          guess_to_check[i] = false
          code_to_check[i] = false
        end
      end
    end

    #Check for black pins
    value_to_match = []
    code.each_index do |i|
      if code_to_check[i] == true
        value_to_match << code[i]
      end
    end

    guess.each_with_index do |symbol, i|
      if guess_to_check[i]
        if (value_to_match.include?(guess[i]))
          this_turn_feedback.push("black")
          for x in 0..(value_to_match.length) do
            if value_to_match[x] == guess[i]
              value_to_match.delete_at(x)
              break
            end
          end
        end
      end
    end

    #make sure that the feedback will be of length 4
    until this_turn_feedback.length == 4
      this_turn_feedback.push("")
    end
    this_turn_feedback
    session[:previous_fb].push(this_turn_feedback)
  end

  def check_victory
    if session[:previous_fb][-1] == ["white", "white", "white", "white"]
      return true
    end
  end

end

enable :sessions

get '/' do
  erb :index
end

get '/codemaker' do
  @ai_lost = false
  @color1 = params[:color1].to_i
  @color2 = params[:color2].to_i
  @color3 = params[:color3].to_i
  @color4 = params[:color4].to_i
  session[:secret_code] = [@color1, @color2, @color3, @color4]
  @color_code1 = find_color(@color1)
  @color_code2 = find_color(@color2)
  @color_code3 = find_color(@color3)
  @color_code4 = find_color(@color4)
  session[:current_turn] = 0
  session[:previous_fb] = []
  session[:previous_guess] = []
  session[:aiwon] = false
  session[:ailost] = false
  ai_game_loop
  if session[:ailost] == true
    erb :play, :locals => {:session => session, :lose => false, :victory => false, :ailost => true, :aiwin => false}
  else
    erb :play, :locals => {:session => session, :lose => false, :victory => false, :ailost => false, :aiwin => false}
  end

end

get '/codebreaker' do
  session[:secret_code] = create_code
  session[:current_turn] = 0
  session[:previous_fb] = []
  session[:previous_guess] = []
  session[:victory] = false
  session[:lose] = false
  erb :play, :locals => {:session => session, :lose => false, :victory => false, :ailost => false, :aiwin => false}
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
  if check_victory
    session[:victory] = true
  end
  session[:current_turn] += 1
  if session[:current_turn] >= 12
    erb :play, :locals => {:session => session, :lose => true, :victory => false, :ailost => false, :aiwin => false}
  elsif session[:victory] == true
    erb :play, :locals => {:session => session, :lose => false, :victory => true, :ailost => false, :aiwin => false}
  else
    erb :play, :locals => {:session => session, :lose => false, :victory => false, :ailost => false, :aiwin => false}
  end

end
