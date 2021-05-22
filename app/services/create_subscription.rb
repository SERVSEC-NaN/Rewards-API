# frozen_string_literal: true

module Rewards
  # Add a subscriber to an existing promoter
  class CreateSubscription
    def self.call(subscriber_id:, promoter_id:)
      Subscriber
        .find(id: subscriber_id)
        .add_promoter(Promoter.find(id: promoter_id))
    end
  end
end
