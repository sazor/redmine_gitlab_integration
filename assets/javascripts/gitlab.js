$(document).ready(function(){
	var gitlab = {};
	$('#gitlab_auth').click(function(){
		var login = $('#gitlab_login').val();
		var pass = $('#gitlab_pass').val();
		var url = $('#gitlab_url').val() + '/api/v3';
		$.post(url + '/session', { login: login, password: pass })
			.done(function(data){
				gitlab = data;
				$('#auth_status').empty().append("Logged in as " + gitlab.username + ".").removeClass("error notice").addClass("notice").show();
				$('#gitlab_fieldset').slideDown();
			})
			.fail(function(data){
				gitlab = {};
				$('#auth_status').empty().append("Authorization failed!").removeClass("error notice").addClass("error").show();
				$('#gitlab_fieldset').hide();
			});
	});
});
