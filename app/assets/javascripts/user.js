
function UserViewModel(user){
  var self = this;

  self.id = user.id;
  self.email = user.email;
  self.name = user.name;
  self.surname = user.surname;
  self.avatar = user.avatar;
  self.online = user.online;
  self.tasks_count = user.tasks_count;
};

