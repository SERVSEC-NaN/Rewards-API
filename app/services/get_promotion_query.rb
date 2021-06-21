# frozen_string_literal: true

module Rewards
  # Allow a subscriber to view promoter's existing promotion
  class GetPromotionQuery
    # Error for cannot find a promotion
    class NotFoundError < StandardError
      def message
        'We could not find that promotion'
      end
    end

    def self.call(auth:, promotion:)
      raise NotFoundError unless promotion

      policy = PromotionPolicy.new(auth[:account], promotion, auth[:scope])
      raise ForbiddenError unless policy.can_view?

      promotion.full_details.merge(policies: policy.summary)
    end
  end
end
