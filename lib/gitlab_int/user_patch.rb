module GitlabInt
	module UserPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do  
      	validate :gitlab_token_is_valid
        safe_attributes :gitlab_token
      end
    end
    module InstanceMethods
    	include GitlabMethods
    	def gitlab_token_is_valid
    		unless gitlab_token_valid? gitlab_token
    			errors.add(:gitlab_token, t(:gitlab_token_error))
    		end
    	end
    end
	end
end
