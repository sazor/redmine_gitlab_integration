module GitlabInt
	module ProjectPatch
    def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)  
  
      base.class_eval do  
        alias_method_chain :delete_unsafe_attributes, :gitlab
        has_many :git_lab_repositories, dependent: :destroy
        before_destroy :remove_gitlab_repositories
      end
    end
  
    module ClassMethods   
    end
  
    module InstanceMethods
    	def delete_unsafe_attributes_with_gitlab(attrs, user)
    		create_gitlab_repository(attrs["gitlab_name"], attrs["gitlab_description"], attrs["gitlab_id"], attrs["visibility"])
    		delete_unsafe_attributes_without_gitlab(attrs, user)
    	end

      def create_gitlab_repository(name, description, uid, visibility)
      	glr = GitLabRepository.new
      	glr.smart_attributes = { title: name, description: description, uid: uid, visibility: visibility }
      	glr.save
      	self.git_lab_repositories.push glr
      end

      def remove_gitlab_repositories

      end
    end
	end
end
