# frozen_string_literal: true

require 'rest-client'
require 'json'

URL     = 'http://127.0.0.1:3000'
API_URL = "#{URL}/api/v1"

p 'Interaction with the BASE URL'
gets
response = RestClient.get URL
p response.body

p 'Create promoter'
gets
p promoter_data = {
  email: 'food@robertsinc.com',
  name: 'Food & Beverages',
  organization: 'Roberts Inc'
}.to_json

gets
response = RestClient.post "#{API_URL}/promoters", promoter_data, { content_type: :json, accept: :json }
p response.body

p "We got promoter's ID"
body = JSON.parse(response.body)
promoter_id = body['data']['attributes']['id']
p promoter_id
gets

p 'Create a promotion on behalf of this promoter'
promotion_data = {
  title: 'Mooncake Festival',
  description: 'Get mooncakes for loved ones for half the price'
}.to_json
p promotion_data
gets

response = RestClient.post "#{API_URL}/promoters/#{promoter_id}/promotions", promotion_data,
                           { content_type: :json, accept: :json }

p response.body
gets
