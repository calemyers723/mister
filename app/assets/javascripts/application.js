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
//= require_tree .

window.fbAsyncInit = function() {
    FB.init({
        appId: '409570049205375',
        status: true,
        cookie: true,
        xfbml: true
    });

    //do stuff
}; //<-- semicolon required!

(function(d, debug){
     var js, id = 'facebook-jssdk', ref = d.getElementsByTagName('script')[0];
     if (d.getElementById(id)) {return;}
     js = d.createElement('script'); js.id = id; js.async = true;
     js.src = "//connect.facebook.net/en_US/all" + (debug ? "/debug" : "") + ".js";
     ref.parentNode.insertBefore(js, ref);
}(document, /*debug*/ false));

function share_facebook() {
  FB.ui({
     method: 'share_open_graph',
     action_type: 'og.likes',
     action_properties: JSON.stringify({
      object:'https://developers.facebook.com/docs/',
      message: "Look Good. Be Confident. Didn't want to leave you all behind. Check out Mister Pompadour's hair products here."
     }),
   }, function(response){});

  // FB.ui({
  //   method: 'share',
  //   href: 'https://developers.facebook.com/docs/',
  // }, function(response){});
}