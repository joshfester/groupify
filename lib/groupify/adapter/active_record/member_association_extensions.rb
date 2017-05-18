module Groupify
  module ActiveRecord
    module MemberAssociationExtensions
      include AssociationExtensions

      def <<(*children)
        add_children_to_parent(:member, *children, &super)
      end
      alias_method :add, :<<

    protected

      def find_memberships_for_adding_children(member, group, membership_type)
        member.group_memberships_as_member.where(group_id: group.id, membership_type: membership_type)
      end

      def find_for_destruction(membership_type, *members)
        proxy_association.owner.group_memberships_as_group.
          where(member_id: members.map(&:id), member_type: proxy_association.reflection.options[:source_type]).
          as(membership_type)
      end
    end
  end
end