module GitlabInt
	module UserPatch
    def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)  
  
      base.class_eval do  
        safe_attributes :gitlab_token
      end
    end
  
    module ClassMethods   
    end
  
    module InstanceMethods
    end
	end
end
