# frozen_string_literal: true

module Rewards
  # Service object to create a new subscription for a promoter
  class CreatePromotion
    def self.call(promoter_id:, promotion_data:)
      Promoter
        .find(id: promoter_id)
        .add_promotion(promotion_data)
    end
  end
end
