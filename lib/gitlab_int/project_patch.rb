module GitlabInt
	module ProjectPatch
    def self.included(base)
      base.send(:include, InstanceMethods)  
  
      base.class_eval do  
        alias_method_chain :delete_unsafe_attributes, :gitlab
        has_many :git_lab_repositories, dependent: :destroy
        validate :gitlab_errors?
        attr_accessor :gitlab_err
      end
    end
  
    module InstanceMethods
    	def delete_unsafe_attributes_with_gitlab(attrs, user)
    		if attrs["gitlab_token"] && !attrs["gitlab_token"].empty? && (attrs["gitlab_create"] == "true")
          create_gitlab_repository(attrs["gitlab_name"], attrs["gitlab_description"], attrs["visibility"], attrs["gitlab_token"])
    		end
    		delete_unsafe_attributes_without_gitlab(attrs, user)
    	end

      def create_gitlab_repository(name, description, visibility, token)
        begin
        	glr = GitLabRepository.new
        	glr.smart_attributes = { title: name, description: description, visibility: visibility, token: token }
        	glr.save
        	self.git_lab_repositories << glr
        rescue
          @gitlab_err = true
        end
      end

      def gitlab_errors?
          errors.add(:base, "Problems with Gitlab Repository. It can be caused by wrong field input, invalid private token or problems with gitlab server.") if @gitlab_err
      end
    end
	end
end
