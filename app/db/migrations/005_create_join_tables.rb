# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_join_table subscriber_id: :subscribers, subscription_id: :subscriptions
    create_join_table tag_id: :tags, subscription_id: :subscriptions
    create_join_table promoter_id: :promoters, subscription_id: :subscriptions
  end
end
