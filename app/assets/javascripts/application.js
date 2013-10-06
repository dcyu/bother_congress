// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= handlebars
//= require_tree .

var page_state;

$(document).ready(function() {
  var save_state = function(callback){
    $.ajax({
      url: "/save_state",
      data: JSON.stringify(page_state),
      contentType: "application/json; charset=utf-8",
      dataType: "json",
      type: "POST",
      success: function(){
        callback();
      },
    });
  };

  var apply_state = function(state){
    page_state = state;
    $(".message").val(page_state.message);
    $(".l-window").css({right: String(page_state.page*150) + "%"});
    cls = ['.first','.second','.third'][page_state.page];
    $(".l-container").show();
    var height = $(".l-container"+cls).height();
    $(".l-wrapper").css("height", height + 10);
    refresh_buttons();
  }

  var refresh_buttons = function(){
    var f = function(id, flag){
      if (flag === true){
        $(id).addClass('highlighted');
      } else {
        $(id).removeClass('highlighted');
      }
    }
    f("#facebook_button", page_state.facebook_enabled);
    f("#twitter_button", page_state.twitter_enabled);
    f("#phone_button", page_state.phone_enabled);
    f("#email_button", page_state.email_enabled);
  } 

  // INIT_STATE comes from the template file, and
  // contains all of the default values for the page
  apply_state(INIT_STATE);


  $(".old-message").on("click", function() {
    page_state.message = $(this).html();
    $(".message").val(page_state.message);
    $(".message-draft").show().html(page_state.message);
  });

  $(".message").on("keyup", function() {
    page_state.message = $(this).val();
    $(".message").val(page_state.message);
    $(".message-draft").show().html(page_state.message);
  });



  $(".next-link").on("click", function(e) {
    e.preventDefault();
    $(".l-container").show();
    $(this).closest(".l-window").animate({right: "+=150%"});
    var height = $(this).closest(".l-container").next().height();
    $(".l-wrapper").css("height", height + 10);
    page_state.page += 1;
    save_state();
  });

  $(".previous-link").on("click", function(e) {
    e.preventDefault();
    $(this).closest(".l-window").animate({right: "+=-150%"});
    var height = $(this).closest(".l-container").prev().height();
    $(".l-wrapper").css("height", height + 10);
    page_state.page -= 1;
    save_state();
  });


  $("#facebook_button").on("click", function(e){
    if (page_state.facebook_enabled === false){
      save_state(function(){
        window.location.href = "/auth/facebook";
      });
    } else {
      page_state.facebook_enabled = false;
      save_state();
      refresh_buttons();
    }
  });

  $("#twitter_button").on("click", function(e){
    if (page_state.twitter_enabled === false){
      save_state(function(){
        window.location.href = "/auth/twitter";
      });
    } else {
      page_state.twitter_enabled = false;
      save_state();
      refresh_buttons();
    }
  });

  $("#email_button").on("click", function(e){
    if (page_state.email_enabled === false){
      if (page_state.email_address === null || page_state.email_address === ''){
        // TODO: fixme
        page_state.email_address = prompt("Please enter your email address.");
      }
      page_state.email_enabled = true;
    } else {
      page_state.email_enabled = false;
    }
    save_state();
    refresh_buttons();
  });

  $("#phone_button").on("click", function(e){
    page_state.phone_enabled = !page_state.phone_enabled;
    save_state();
    refresh_buttons();
  });

});
