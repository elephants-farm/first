function ProjectAttr(project){
  var self = this;
  self.name = ko.observable(project.name);
  self.description = ko.observable(project.description);
};

function ProjectViewModel(project){
  var self = this;
  self.id = project.id;
  self.__attr__ = ko.observable(new ProjectAttr(project));
  self.errors = ko.observable();
  
  self.clear_errors = function(){
    self.errors(null);  
  };

  self.clear_all = function(){
    self.errors(null);
    self.__attr__( new ProjectAttr( new EmptyProject() ) );
  };

  self.error_by_field = function(field){
    return self.errors() ? self.errors()[field] ? self.errors()[field][0] : '' : '' 
  };
  
};


function EmptyProject()  {
  this.id = null;
  this.name = null;
  this.description = null;
};