class Upload < ActiveRecord::Base
  attr_accessible :upload
  has_attached_file :upload

  include Rails.application.routes.url_helpers

  def to_jq_upload
    res = {
      name: read_attribute(:upload_file_name),
      size: read_attribute(:upload_file_size),
      url: upload.url(:original),
      delete_url: upload_path(self),
      delete_type: "DELETE" 
    }
    res.merge!(thumbnail_url: upload.url(:original)) if self.upload_content_type.split('/').first.to_sym == :image
    res
  end

end
