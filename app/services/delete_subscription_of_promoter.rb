# frozen_string_literal: true

module Rewards
  # Service object to delete a subscription belonging to a promoter
  class DeleteSubscriptionOfPromoter
    def self.call(promoter_id:, subscription_id:)
      Promoter
        .find(id: promoter_id)
        .remove_subscription Subscription.find(id: subscription_id)
    end
  end
end
