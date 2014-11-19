$(document).ready(function(){
  $('#project_gitlab_create').removeAttr('checked');
  var gitlab = {};
  $('#project_gitlab_create').change(function(){
    if($(this).is(':checked')){
      $('#project_gitlab_name').val($('#project_name').val());
      $('#project_gitlab_description').val($('#project_description').val());
      $('#gitlab_fieldset').slideDown();
    }
    else{
      $('#gitlab_auth_form').hide();
      $('#gitlab_fieldset').hide();
    }
  });
});
