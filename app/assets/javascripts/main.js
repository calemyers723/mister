$(document).ready(function(){

	$("#owl_imran").owlCarousel({
	 
	navigation :false, // Show next and prev buttons
	slideSpeed : 300,
	paginationSpeed : 400,
	items:1,
	pagination: true,
	autoPlay : true,
	navigationText: [
      "<i class='fa fa-angle-left' id='mainslider'></i>",
      "<i class='fa fa-angle-right' id='mainslider'></i>"
      ],
	   
	 singleItem:true
	// itemsDesktop : false,
	 //itemsDesktopSmall : false,
	});
	// alert(1);
});
