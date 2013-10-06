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
//= require handlebars
//= require_tree .

$(document).ready(function() {
  
  $(".message").focus();

  $(".old-message").on("click", function() {
    var message = $(this).html();
    $(".message").val(message);
  });

  $(".next-link").on("click", function(e) {
    e.preventDefault();
    $(".l-container").show();
    $(this).closest(".l-window").animate({right: "+=150%"});
    var height = $(this).closest(".l-container").next().height();
    $(".l-wrapper").css("height", height + 10);
  });

  $(".previous-link").on("click", function(e) {
    e.preventDefault();
    $(this).closest(".l-window").animate({right: "+=-150%"});
    var height = $(this).closest(".l-container").prev().height();
    $(".l-wrapper").css("height", height + 10);
  });

  var height = $(".l-container:nth-child(1)").height();
  $(".l-wrapper").css("height", height + 10);

});
