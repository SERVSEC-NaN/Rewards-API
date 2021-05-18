# frozen_string_literal: true

module Rewards
  # Service object to create a new subscription for a promoter
  class CreateSubscriptionForPromoter
    def self.call(promoter_id:, subscription_data:)
      Promoter
        .find(id: promoter_id)
        .add_subscription(subscription_data)
    end
  end
end
