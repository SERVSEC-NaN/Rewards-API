# frozen_string_literal: true

module Rewards
  # Remove a subscriber from a subscription
  class RemoveSubscriberFromSubscription
    def self.call(subscriber_id:, subscription_id:)
      Subscriber
        .find(id: subscriber_id)
        .remove_subscriber(Subscription.find(id: subscription_id))
    end
  end
end
