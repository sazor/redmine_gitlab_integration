$(document).ready(function(){
	var gitlab = {};
	$('#gitlab_auth').click(function(){
		var login = $('#gitlab_login').val();
		var pass = $('#gitlab_pass').val();
		var url = $('#gitlab_url').val() + '/api/v3';
		$.post(url + '/session', { login: login, password: pass }, function(data){
			gitlab = data;
		});
	});
});
