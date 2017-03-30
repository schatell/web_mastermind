$(document).ready(
  function(){
    $("#how_to").click(function(){
      $('#instruction').animate({
        left: $("#instruction").parent().width()/2 - $("#instruction").width()/2
      }, 500);
    });
    $('#close').click(function(){
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
      }, 500);
      $('.main_container').css('overflow','hidden');
    });
    $('#back_arrow').click(function(){
      $('#menu').animate({
        right: "0", left :"0"
      }, 500);
      $('#player_type').animate({
        right: '-2000px'
      },500,function(){
        $('.main_container').css('overflow','visible')
      });
    });
    $('#codemaker').click(function(){
      $('#player_type').animate({
        left: '-2000px'
      }, 500);
      $('#code_maker_menu').animate({
        right: '0'
      }, 500);
    })
  }
)
