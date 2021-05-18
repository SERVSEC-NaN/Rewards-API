# frozen_string_literal: true

module Rewards
  # Add a subscriber to an existing subscription
  class AddSubscriberToSubscription
    def self.call(subscriber_id:, subscription_id:)
      Subscriber
        .find(id: subscriber_id)
        .add_subscription(Subscription.find(id: subscription_id))
    end
  end
end
