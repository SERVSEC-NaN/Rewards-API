# frozen_string_literal: true

module Rewards
  # Add a tag to a promoter's existing subscription
  class AddTagToSubscription
    def self.call(tag_id:, subscription_id:)
      Subscription
        .first(id: subscription_id)
        .add_tag(Tag.find(id: tag_id))
    end
  end
end
