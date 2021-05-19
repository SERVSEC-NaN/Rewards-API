# frozen_string_literal: true

module Rewards
  # Add a tag to a promoter's existing subscription
  class AddTagtoPromotion
    def self.call(promotion_id:, tag_id:)
      Promotion
        .first(id: promotion_id)
        .add_tag(Tag.find(id: tag_id))
    end
  end
end
