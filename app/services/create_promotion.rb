# frozen_string_literal: true

module Rewards
  # Service object to create a new promotion for a promoter
  class CreatePromotion
    def self.call(promoter_id:, promotion_data:)
      Promoter
        .first(id: promoter_id)
        .add_promotion(promotion_data)
    end
  end
end
