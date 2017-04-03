var back_button = 'playertype';

$(document).ready(function(){

  //Show the instructions
    $("#how_to").click(function(){
      $('#instruction').show();
      $('#instruction').animate({
        left: $("#instruction").parent().width()/2 - $("#instruction").width()/2
      }, 500);
    });

    //Close the instructions
    $('#close').click(function(){
      $('#instruction').animate({
        left: "-2000px"
      }, 500, function(){
        $('#instruction').hide();
      });
    });

    //SlideIn the new game menu, hide the overflow
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
      //Also bring with him the back arrow
      $('#back_arrow').animate({
        right: $("#back_arrow").parent().width()/2 - $("#back_arrow").width()/2
      }, 300);
      $('.main_container').css('overflow','hidden');
    });

    //Control of the back button, contextual
    $('#back_arrow').click(function(){
      if (back_button == 'playertype') {
        $('#menu').show();
        $('#menu').animate({
          right: "0", left :"0"
        }, 500);
        $('#player_type').animate({
          right: '-2000px'
        },500,function(){
          $('.main_container').css('overflow','visible');
          $('#player_type').hide();
        });
        $('#back_arrow').animate({
          right: '-2000px'
        }, 100);
      }else {
        $('#player_type').show()
        $('#code_maker_menu').animate({
          right: '-2000px'
        }, 500, function(){
          $('#code_maker_menu').hide();
        })
        $('#player_type').animate({
          left: '0'
        }, 500);
        back_button = 'playertype'
      };
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
      back_button = 'code_maker'
    })
  }
)
