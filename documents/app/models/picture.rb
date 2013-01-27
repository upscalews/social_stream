class Picture < Document

  file_upload_path = "#{SocialStream::Documents.upload_path}documents/:class/:id_partition/:style"

  has_attached_file :file, 
                    :url => '/:class/:id.:content_type_extension',
                    :path => file_upload_path,
                    :styles => SocialStream::Documents.picture_styles
                               
  define_index do
    activity_object_index

    indexes file_file_name, :as => :file_name
  end    
end
