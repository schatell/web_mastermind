$(document).ready(
  function(){
    $("#how_to").click(function(){
      $('#instruction').animate({
        left: $("#instruction").parent().width()/2 - $("#instruction").width()/2
      }, 500);
    });
    $('.logo').click(function(){
      $('#instruction').animate({
        left: "-2000px"
      }, 500);
    });
    $('#newgame').click(function(){
      $('#menu').animate({
        left: "-3000px"
      }, 500);
      $('#player_type').animate({
        right: "0"
      }, 500)
    });
  }
)
