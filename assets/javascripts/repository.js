$(document).ready(function(){
	$('.url_btn').click(function(){
		$(this).siblings('.project_clone').val($(this).attr('data-clone'));
		$(this).siblings('.url_btn.active').removeClass('active');
		$(this).addClass('active');
	});
	$(".project_clone").click(function () {
  	$(this).select();
	});
});
