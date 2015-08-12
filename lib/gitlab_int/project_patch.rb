module GitlabInt
  module ProjectPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        alias_method_chain :delete_unsafe_attributes, :gitlab
        has_many :git_lab_repositories, dependent: :destroy
        safe_attributes :gitlab_group
        validates_presence_of :gitlab_group, if: :should_create_gitlab?
        after_save :create_gitlab_repository, on: :create, if: :should_create_gitlab?
        attr_accessor :gitlab_attrs
      end
    end

    module InstanceMethods
      def delete_unsafe_attributes_with_gitlab(attrs, user)
        if attrs["gitlab_create"] == "true"
          @gitlab_attrs = {
                            title: attrs['gitlab_name'],
                            description: attrs['gitlab_description'],
                            identifier: attrs['identifier'],
                            visibility: attrs['is_public'],
                            user_id: User.current.id,
                            context: :create,
                            token: User.current.gitlab_token
                          } # Save some attributes for gitlab
          if group = GitLabRepository.gitlab_create_group(@gitlab_attrs) # Create group for project
            @gitlab_attrs[:group] = attrs[:gitlab_group] = group.id
            GitLabRepository.gitlab_member(@gitlab_attrs.merge({ op: :add })) # Add project owner to this group
          end
        end
        delete_unsafe_attributes_without_gitlab(attrs, user)
      end

      def should_create_gitlab?
        @gitlab_attrs.present?
      end

      def create_gitlab_repository
        GitLabRepository.new.build(@gitlab_attrs.merge({ project_id: self.id })).save
      end
    end
  end
end
