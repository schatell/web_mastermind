$(document).ready(function(){

  //Set the back button relative to the state of the page on load
  var back_button = 'playertype';

  //This function store the possible color in an array
  function setColor(index) {
    var colors = ["#E60000",
                  "#0066FF",
                  "#ffff00",
                  "#009933",
                  "#993366",
                  "#00ffcc"]
    return colors[index];
  }

  //This function convert the pin id to an integer
  function find_pin_number(number) {
    if (number == "pin1") {
      clicked_once[0] = 1;
      return 0;
    }
    else if (number == "pin2") {
      clicked_once[1] = 1;
      return 1;
    }
    else if (number == "pin3") {
      clicked_once[2] = 1;
      return 2;
    }
    else if (number == "pin4") {
      clicked_once[3] = 1;
      return 3;
    }
  }

  //Check if each pin was colored
  function check_clicked_once(number){
    return number == 1;
  }

  //Numerical storing of color
  var indexes = [0, 0, 0, 0];

  //Get a 1 once the pin has been clicked at least once
  var clicked_once = [0, 0, 0, 0];

  //Make the submit button unclickable
  $(".inactive").prop('disabled', 'disabled');


  //Show the instructions
    $("#how_to").click(function(){
      $('#instruction').show();
      $('#instruction').animate({
        left: $("#instruction").parent().width()/2 - $("#instruction").width()/2
      }, 500);
      $(".main_container").css("overflow", "visible");
    });

    //Close the instructions
    $('#close').click(function(){
      $('#instruction').animate({
        left: "-2000px"
      }, 500, function(){
        $('#instruction').hide();
        $(".main_container").css("overflow", "hidden");
      });
    });

    //SlideIn the new game menu
    $('#newgame').click(function(){
      $('#menu').animate({
        left: "-2000px"
      }, 500, function(){
        $('#menu').hide();
      });

      //Show the player menu and animate it
      $('#player_type').show();
      $('#player_type').animate({
        right: "0"
      }, 500);
      $("#player_type").css("display", "flex")
      //Also bring with him the back arrow
      $('#back_arrow').animate({
        right: $("#back_arrow").parent().width()/2 - $("#back_arrow").width()/2
      }, 300);
      $("#back_arrow").css("display", "flex");
    });

    //Control of the back button, contextual
    $('#back_arrow').click(function(){
      if (back_button == 'playertype') {
        $('#menu').show();
        $('#menu').animate({
          right: "0", left :"0"
        }, 500);
        $(this).css("display", "flex");
        $('#player_type').animate({
          right: '-2000px'
        },500,function(){
          $('#player_type').hide();
        });
        $('#back_arrow').animate({
          right: '-2000px'
        }, 100);
        $('#back_arrow').css("display", "none");
      }else if ((back_button == 'code_maker')) {
        $('#player_type').show()
        $('#code_maker_menu').animate({
          right: '-2000px'
        }, 500, function(){
          $('#code_maker_menu').hide();
        })
        $('#player_type').animate({
          left: '0'
        }, 500);
        $("#code_maker_menu").css("display", "flex");
        back_button = 'playertype'
      } else if (back_button == 'code_breaker') {
        $('#player_type').show()
        $('#code_breaker_menu').animate({
          right: '-2000px'
        }, 500, function(){
          $('#code_breaker_menu').hide();
        })
        $('#player_type').animate({
          left: '0'
        }, 500);
        $("#player_type").css("display", "flex");
        back_button = 'playertype'
      }
    });

    //SlideIn the CodeMaker menu
    $('#codemaker').click(function(){
      $('#player_type').animate({
        left: '-2000px'
      }, 500, function(){
        $('#player_type').hide();
      });

      //Show the CodeMakerMenu and animate it
      $('#code_maker_menu').show();
      $('#code_maker_menu').animate({
        right: '0'
      }, 500);
      $("#code_maker_menu").css("display", "flex")
      back_button = 'code_maker'
    })

    //SlideIn the CodeMaker menu
    $('#codebreaker').click(function(){
      $('#player_type').animate({
        left: '-2000px'
      }, 500, function(){
        $('#player_type').hide();
      });

      //Show the CodeMakerMenu and animate it
      $('#code_breaker_menu').show();
      $('#code_breaker_menu').animate({
        right: '0'
      }, 500);
      $("#code_breaker_menu").css("display", "flex");
      back_button = 'code_breaker'
    })

    //Set the color of individual pin on click
    $('.pin').click(function(){
      if (indexes[find_pin_number(this.id)] <= 5) {
        $(this).css({'background-color' : setColor(indexes[find_pin_number(this.id)])});
        indexes[find_pin_number(this.id)] += 1;
        if (clicked_once.every(check_clicked_once)) {
          $('#play_button').removeClass("inactive");
          $("#play_button").removeAttr('disabled');
          $('#play_next').removeClass("inactive");
          $("#play_next").removeAttr("disabled");
        };
      }
      else {
        (indexes[find_pin_number(this.id)]) = 0;
        $(this).css({'background-color' : setColor(0)});
        indexes[find_pin_number(this.id)] += 1;
        if (clicked_once.every(check_clicked_once)) {
          $('#play_button').removeClass("inactive");
          $("#play_button").removeAttr('disabled');
          $('#play_next').removeClass("inactive");
          $("#play_next").removeAttr("disabled");
        };
      };
    });

    //When the codemakerform is submited, it will append params so the server know about the code
    $('#code_maker_form').submit(function(e){
      $(this).append("<input type='hidden' name='color1' value=" + (indexes[0]-1) + " >");
      $(this).append("<input type='hidden' name='color2' value=" + (indexes[1]-1) + " >");
      $(this).append("<input type='hidden' name='color3' value=" + (indexes[2]-1) + " >");
      $(this).append("<input type='hidden' name='color4' value=" + (indexes[3]-1) + " >");
    });

    //When a guess is submited, it append input so the params are transfered to the server
    $('#next_guess').submit(function(e){
      $(this).append("<input type='hidden' name='guess1' value=" + (indexes[0]-1) + " >");
      $(this).append("<input type='hidden' name='guess2' value=" + (indexes[1]-1) + " >");
      $(this).append("<input type='hidden' name='guess3' value=" + (indexes[2]-1) + " >");
      $(this).append("<input type='hidden' name='guess4' value=" + (indexes[3]-1) + " >");
    });

  }
);
