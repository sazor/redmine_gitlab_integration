$(document).ready(function(){
  $('#project_gitlab_create').removeAttr('checked');
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
        $('#project_gitlab_token').val(gitlab.private_token);
      })
      .fail(function(data){
        gitlab = {};
        $('#auth_status').empty().append("Authorization failed!").removeClass("error notice").addClass("error").show();
        $('#gitlab_fieldset').hide();
        $('#project_gitlab_token').val('');
      });
  });
  $('#project_gitlab_create').change(function(){
    if($(this).is(':checked')){
      if($('#gitlab_auth_form').length){
        $('#gitlab_auth_form').slideDown();
        if($('#project_gitlab_token').val() != ''){
          $('#project_gitlab_name').val($('#project_name').val());
          $('#project_gitlab_description').val($('#project_description').val());
          $('#gitlab_fieldset').slideDown();
        }
      }
      else{
        $('#project_gitlab_name').val($('#project_name').val());
        $('#project_gitlab_description').val($('#project_description').val());
        $('#gitlab_fieldset').slideDown();
      }
    }
    else{
      $('#gitlab_auth_form').hide();
      $('#gitlab_fieldset').hide();
    }
  });
});
