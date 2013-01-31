module SocialStream
  module Views
    module Sidebar
      module Base
        def sidebar_items type
          SocialStream::Views::List.new.tap do |items|
            if type == :group_index
              items << {
                :key => 'group.cloud',
                :html => render(:partial => 'groups/tag_cloud')
              }

            end 

            if user_signed_in?
              items << {
                :key => 'suggestions_and_pendings',
                :html => render(:partial => 'sidebar/suggestions_and_pendings')
              }
            end

            if profile_or_current_subject
              items.unshift :key => 'calendar',
                            :html => render(:partial => 'sidebar/calendar')
            end
          end
        end
      end
    end
  end
end

