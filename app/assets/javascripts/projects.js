
function ManageProjectsViewModel(){
  var self = this;
  self.current_project = ko.observable(new ProjectViewModel(new EmptyProject()));
  self.working = ko.observable(false);
  self.data_loading = ko.observable(false);
  self.current_project_state_template = ko.observable();
  
  self.projects = ko.observableArray([]);

  self.new_project = function(project){
    console.log('load_users');
    console.log(project);
    
  };

  self.new_project = function(){
    $('#create-project').modal();    
    self.current_project_state_template('new_project_template');
    self.current_project().clear_all();
  };

  self.delete_project = function(project){
    $.ajax({
        url: "/projects/" + project.id,
        type: 'DELETE',
        dataType: "json",
        success: function(response) {
          self.load_projects();
        },
        failure: function(response) {},
        error: function(response) {}
      });
  };

  self.create_project = function(){
    if(self.working())
      return;
    self.current_project().clear_errors();
    self.working(true);
    var send_data = {
      __attr__: ko.toJS(self.current_project().__attr__)
    };

    $.ajax({
        url: "/projects",
        type: 'POST',
        data: send_data,
        dataType: "json",
        success: function(response) {
          console.log(response);
          self.working(false);
          self.current_project_state_template('new_project_created_meessage_template');
          self.load_projects();
        },
        failure: function(response) {},
        error: function(response) {
          self.current_project().errors($.parseJSON(response.responseText));
          self.working(false);
        }
      });
  };


  self.init_projects_from_json = function(projects){
    self.projects([]);
    ko.utils.arrayForEach(projects, function(item) {
      var project = new ProjectViewModel(item);
      self.projects.push(project);
    });
  };

  self.load_projects = function(){        
    self.data_loading(true);
    $.getJSON("/projects", function(data) { 
      self.init_projects_from_json(data);
      self.data_loading(false);
    });
  };
};