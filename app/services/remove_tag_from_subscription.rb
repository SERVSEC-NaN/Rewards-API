# frozen_string_literal: true

module Rewards
  # Remove a tag from a promoter's existing subscription
  class RemoveTagFromSubscription
    def self.call(tag_name:, subscription_id:)
      Subscription
        .first(id: subscription_id)
        .remove_tag Tag.find(name: tag_name)
    end
  end
end
