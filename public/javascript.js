$(document).ready(
  function(){
    $("#how_to").click(function(){
      $('#instruction').animate({
        left: $("#instruction").parent().width()/2 - $("#instruction").width()/2
      }, 550);
    });
    $('.logo').click(function(){
      $('#instruction').animate({
        left: "-2000px"
      }, 550);
    });
  }
)
