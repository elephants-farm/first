class UserProfile < ActiveRecord::Base
  # attr_accessible :title, :body
  has_attached_file :avatar,
    styles: {
        micro: "25x25",
        mini: "50x50",
        small: "100x100",
        standart: "200x200"
    },
    :default_url => '/assets/avatar_missing/missing_:style.png'
end
