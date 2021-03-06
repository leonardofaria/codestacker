// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs

$(document).on("ready", function() {

	$(".tagcloud").each(function() {
	  $.data(this, "realHeight", $(this).height());
	}).css({ overflow: "hidden", height: "240px" });

	$('.tagcloud_before').on('click', function() {
		if ($('.tagcloud').height() == $('.tagcloud').data("realHeight")) {
			$('.tagcloud').animate({ height: '160px' }, 600).css("margin-bottom", 0);
			$('.tagcloud_after').show();
			$('.tagcloud_before').text('Tagcloud +');
		} else {
			$('.tagcloud').animate({ height: $('.tagcloud').data("realHeight") }, 600).css("margin-bottom", 5);
			$('.tagcloud_before').text('Tagcloud -');
			$('.tagcloud_after').hide();
		}
	});

});
