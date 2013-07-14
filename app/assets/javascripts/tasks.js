function TasksViewSettings(){
  var self = this;
  self.selected_users = ko.observableArray([]);
  self.selected_tags = ko.observableArray([]);
  self.unassigned_count = ko.observable(0);
  self.show_unassigned = ko.observable(true);

  self.unassigned_count_increment = function(){
    self.unassigned_count(self.unassigned_count()+1);
  };

  self.select_user = function(user){
    var found = false;

    ko.utils.arrayForEach(self.selected_users(), function(item) {
      if(item.id == user.id){
        found = true;
        return;
      }
    });
    if(found)
      self.selected_users.remove(function(item) {return item.id == user.id });
    else
      self.selected_users.push(user);
  };

  self.is_user_selected = function(user){
    var found = false;
    ko.utils.arrayForEach(self.selected_users(), function(item) {
      if(item.id == user.id){
        found = true;
        return;
      }
    });
    return found;
  };

  self.select_tag = function(tag){
    var found = false;
    ko.utils.arrayForEach(self.selected_tags(), function(item) {
      if(item.id == tag.id){
        found = true;
        return;
      }
    });
    if(found)
      self.selected_tags.remove(function(item) {return item.id == tag.id });
    else
      self.selected_tags.push(tag);
  };

  self.is_tag_selected = function(tag){
    var found = false;
    ko.utils.arrayForEach(self.selected_tags(), function(item) {
      if(item.id == tag.id){
        found = true;
        return;
      }
    });

    return found;
  };

  self.to_js = function(){
    var selected_users_ids = [];
    var selected_tags_ids = [];
    ko.utils.arrayForEach(self.selected_users(), function(item) {
      selected_users_ids.push(item.id);
    });
    ko.utils.arrayForEach(self.selected_tags(), function(item) {
      selected_tags_ids.push(item.id);
    });
    return {
              selected_users_ids: ko.toJS(selected_users_ids),
              selected_tags_ids: ko.toJS(selected_tags_ids)
            }
  };
};

function ManageTasksViewModel(project){
  var self = this;
  self.tasks = ko.observableArray([]);
  self.tags = ko.observableArray([]);
  
////////////////////////////////
  self.task_view_settings = ko.observable(new TasksViewSettings());
  self.task_state = ko.observable('task_index_template');
  self.projects = ko.observableArray([]);

  self.current_project = ko.observable(project);
  
  self.employees = ko.observableArray([]);
  self.notice = ko.observable();
  self.current_task = ko.observable();
  self.data_loading = ko.observable(false);
  self.task_submit = ko.observable(false);

  self.load_tags = function(){    
    
    $.getJSON("/tags", function(data) { 
      self.tags([]);
      ko.utils.arrayForEach(data.tags, function(item) {
        self.tags.push(new TagViewModel(item.tag));
      });
    
    });
  };

  self.init_tasks_from_json = function(tasks){
    self.task_view_settings().unassigned_count(0);
    ko.utils.arrayForEach(tasks, function(item) {
      var task = new TaskViewModel(item);
      
      if(!task.TaskAttr().assigned_to_user_id)
        self.task_view_settings().unassigned_count_increment();

      task.load_comments();// debug load after task is opened!!!
      
      task.setup();
      self.tasks.push(task);
    });
  };

  self.load_tasks = function(){
    self.data_loading(true);
    $.post("/projects/" + self.current_project().id + "/fetch_tasks", self.task_view_settings().to_js(), function(data) { 
      self.tasks([]);
      self.init_tasks_from_json(data.tasks);
      self.data_loading(false);
    });
  };

  self.index = function(){
    self.task_state('task_index_template');
  };

  self.set_new_status_for_current_task = function(status){
    self.current_task().TaskAttr().status(status);
    self.save_task();
  };

  self.save_task = function(){
    if(self.task_submit())
        return;
    self.task_submit(true);
    var send_data = {
      id: self.current_task().id,
      taskAttr: ko.toJS(self.current_task().TaskAttr()),
      assigned_users: ko.toJS(self.current_task().assigned_users()),
      tags: ko.toJS(self.current_task().tags())
    };

    if(send_data.id){
      $.ajax({
        url: "/projects/" + self.current_project().id + "/tasks/" + send_data.id,
        type: 'PUT',
        data: send_data,
        success: function(response) {
          self.notice('Updated');
          self.load_tags();
          self.load_projects();
          self.task_submit(false);
        }
      });
    }else{
      $.post("/projects/" + self.current_project().id + "/tasks", send_data, function(response) {
          var task = new TaskViewModel(response);
          task.setup();
          self.tasks.push(task);
          self.notice('Saved');
          self.load_tags();
          self.load_projects();
          self.view_task(task);
          self.task_submit(false);
      }); 
    }
  };
  
  self.new_task = function(){   
    self.current_task(new TaskViewModel(new EmptyTask()));
    self.notice(null);
    self.task_state('task_new_template');
  };
  
  self.view_task = function(task){
    self.notice(null);
    self.current_task(task);
    //self.current_task().load_comments();
    self.task_state('task_show_template');
    self.init_fileupload();
  };

  self.init_fileupload = function(){
    // Initialize the jQuery File Upload widget:
    $('#fileupload').fileupload();
    // Load existing files:
    $.getJSON("/projects/" + self.current_project().id  + "/tasks/" + self.current_task().id + "/fetch_uploads", function (files) {
      var fu = $('#fileupload').data('blueimpFileupload'),template;
      fu._adjustMaxNumberOfFiles(-files.length);
      template = fu._renderDownload(files).appendTo($('#fileupload .files'));
      // Force reflow:
      fu._reflow = fu._transition && template.length && template[0].offsetWidth;
      template.addClass('in');
      $('#loading').remove();
    });
  };

  self.edit_task = function(){
    self.task_state('task_edit_template');
  };

  self.close_task = function(){
    self.current_task().close();
    self.save_task();
    self.index();
  };

  self.load_employees = function(){    
    $.getJSON("/projects/" + self.current_project().id  + "/employees", function(data) { 
      ko.utils.arrayForEach(data, function(item) {
        self.employees.push(new UserViewModel(item.user));
      });
    });
  };

// TODO ????????????/  
  self.load_projects = function(){    
    $.getJSON("/projects", function(data) { 
      self.projects(data);
    });
  };
  

  self.select_tag = function(data){
    self.task_view_settings().select_tag(data);
    self.load_tasks();

    self.index();
  };

  self.select_user = function(data){
    self.task_view_settings().select_user(data);
    //self.load_tasks();

    self.index();
  };

///////////////////////////////////////

//  self.find_project_by_task = function(task){
//    var data = {name: ''};
//    ko.utils.arrayForEach(self.projects, function(item) {
//      if(item.id == task.TaskAttr().project_id){
//        data = item;
//      }
//    });
//    return data;
 // };

  self.priority_to_string  = {1: 'low',2: 'middle',3: 'high',4: 'immediately'};
  self.priority_to_color  = [{id: 4,color: 'rgb(218, 134, 134)'},{id: 3,color: 'rgb(121, 167, 121)'},{id: 2,color: 'rgb(221, 221, 105)'},{id: 1,color: 'rgb(139, 177, 177)'}];
  self.status_to_color  = {1: 'rgb(142, 167, 163)',2: 'rgb(79, 163, 79)',3: 'rgb(92, 70, 112)',4: 'red', 5: 'black'};
  self.status_active_codes = [1, 2, 3];
  self.status_to_string  = {1: 'new',2: 'in progress',3: 'complete',4: 'aborted', 5: 'closed'};

};