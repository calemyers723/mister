$(document).ready(function(){
	var myVideo = document.getElementById('video');
	console.log(myVideo);
	if(myVideo){
		if (typeof myVideo.loop == 'boolean') { // loop supported
		    myVideo.loop = true;
		} else { // loop property not supported
		    myVideo.on('ended', function () {
		    this.currentTime = 0;
		    this.play();
		    }, false);
		}
	}


})

function share_facebook() {
	FB.ui(
	  {
	    method: 'share',
	    href: 'https://developers.facebook.com/docs/',
	  },
	  function(response) {
	    if (response && !response.error_code) {
	      alert('Posting completed.');
	    } else {
	      alert('Error while posting.');
	    }
	  }
	);
}