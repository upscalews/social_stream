class Video < Document  
  file_upload_path = "#{SocialStream::Documents.upload_path}documents/:class/:id_partition/:style" 

  has_attached_file :file, 
                    :url => '/:class/:id.:content_type_extension',
                    :default_url => 'missing_:style.png',
                    :path => file_upload_path,
                    :styles => SocialStream::Documents.video_styles,
                    :processors => [:ffmpeg]
                    
  process_in_background :file
  
  define_index do
    activity_object_index

    indexes file_file_name, :as => :file_name
  end
                      
 # JSON, special edition for video files
  def as_json(options = nil)
    {:id => id,
     :title => title,
     :description => description,
     :author => author.name,
     :poster => file(:poster).to_s,
     :sources => [ { :type => Mime::WEBM.to_s,  :src => file(:webm).to_s },
                   { :type => Mime::MP4.to_s,   :src => file(:mp4).to_s },
                   { :type => Mime::FLV.to_s, :src => file(:flv).to_s }
                 ]
    }
  end
  
end
