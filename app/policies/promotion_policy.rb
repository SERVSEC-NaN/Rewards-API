# frozen_string_literal: true

# Policy to determine if account can view a promotion
class PromotionPolicy
  def initialize(account, promotion, auth_scope = nil)
    @account    = account
    @promotion  = promotion
    @auth_scope = auth_scope
  end

  def can_view?
    can_read? || account_owns_promotion? || account_subscribed_to_promoter?
  end

  def can_edit?
    can_write? && account_owns_promotion?
  end

  def can_delete?
    can_write? && account_owns_promotion?
  end

  def summary
    {
      can_view: can_view?,
      can_edit: can_edit?,
      can_delete: can_delete?
    }
  end

  private

  def can_read?
    @auth_scope ? @auth_scope.can_read?('promotions') : false
  end

  def can_write?
    @auth_scope ? @auth_scope.can_write?('promotions') : false
  end

  def account_owns_promotion?
    @promotion.promoter_id == @account.id
  end

  def account_subscribed_to_promoter?
    Rewards::Promoter
      .find(id: @promotion.promoter_id)
      .subscribers.find(id: @account.id).first
      .exists?
  end
end
