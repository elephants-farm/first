function TaskAttr(task){
  var self = this;
  self.project_id = task.project_id;
  self.name = task.name;
  self.description = task.description;
  self.priority = task.priority;
  self.status = ko.observable(task.status);
  self.creator_user_id = task.author.id;
  self.assigned_to_user_id = task.assigned_to_user_id;
  self.estimate_point = task.estimate_point;
  self.dead_line_time = task.dead_line_time;
  self.finish_to_time = task.finish_to_time;
};

function TaskViewModel(task){
  var self = this;
  self.comments = ko.observableArray([]);
  
  self.current_comment = ko.observable();
  
  self.id = task.id;
  
  self.author = new UserViewModel(task.author);
  self.assigned_to = ko.observable();
//////
  self.assigned_users_objs = task.assigned_users;
///////
  self.assigned_users = ko.observableArray([]);
  self.tags = ko.observableArray([]);

  self.TaskAttr = ko.observable(new TaskAttr(task));  

  self.setup = function(){
    self.init_tags();
    self.init_assigned_to();
    self.init_assigned_users();
  };

  self.init_assigned_to = function(){
    self.assigned_to(task.assigned_to ? new UserViewModel(task.assigned_to) : null);
  };

  self.init_assigned_users = function(){
    ko.utils.arrayForEach(task.assigned_users, function(item) {
      self.assigned_users.push(item.user.id);
    });
  };

  self.init_empty_comment = function(){
    self.current_comment(new CommentViewModel(new EmptyComment()));    
  };

  self.close = function(){
    self.TaskAttr().status = 5;
  };

  self.is_closed = function(){
    return self.TaskAttr().status == 5;
  };

  self.init_tags = function(){
    ko.utils.arrayForEach(task.tags, function(item) {
      self.tags.push(item.tag.name);
    });
  };

  self.load_comments = function(){
    self.init_empty_comment();

    $.getJSON("tasks/" + self.id + "/fetch_comments", function(data) { 
      self.comments.removeAll();
      ko.utils.arrayForEach(data, function(item) {
        self.comments.push(new CommentViewModel(item));
      });
      
    });
  };

  self.post_comment = function(){
    var send_data = {
      task_id: self.id,
      commentAttr: ko.toJS(self.current_comment().commentAttr)
    };
    $.post("tasks/" + self.id + "/new_comment", send_data, function(returnedData) {
      self.comments.unshift(self.current_comment());
      self.init_empty_comment();
    }); 

  };
};

function EmptyTask()  {
  this.id = null;
  this.project_id = null;
  this.name = null;
  this.description = null;
  this.priority = null;
  this.status = 1;
  this.estimate_point = 0;
  this.price2 = null;
  this.author = current_user;
  this.assigned_to = null;
  this.dead_line_time = null;
  this.finish_to_time = null;
 // this.author = new EcoDressUserViewModel({id: current_user.id,email: current_user.email,name: current_user.name, surname: current_user.surname});
};