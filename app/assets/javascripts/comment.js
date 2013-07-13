function CommentAttr(comment){
  var self = this;
  self.description = comment.description;
  self.title = comment.title;
  self.user_id = comment.author.id;
};

function CommentViewModel(comment){
  var self = this;
  self.id = comment.id;
  self.commentAttr = new CommentAttr(comment);  
  self.author = new UserViewModel(comment.author);
};

function EmptyComment()  {
  this.id = null;
  this.title = null;
  this.description = null;
  this.author = new UserViewModel(current_user);
//    ,name: current_user.name, surname: current_user.surname});
};