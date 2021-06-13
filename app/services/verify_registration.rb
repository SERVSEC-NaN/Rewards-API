# frozen_string_literal: true

require 'base64'
require_relative '../models/account'

# Handles email registration
class VerifyRegistation
  class InvalidRegistration < StandardError; end

  def initialize(registration)
    @registration = registration
  end

  def call
    raise InvalidRegistration, 'Email already in use.' unless email_available?

    send_email_verification
  end

  private

  def email_available?
    !Rewards::Account.find(email: @registration[:email]).nil?
  end

  def send_email_verification
    HTTP.auth("Bearer #{mail_api_key}").post(mail_url, json: mail_json)
  rescue StandardError => e
    puts "EMAIL ERROR: #{e.inspect}"
    raise(InvalidRegistration,
          'Could not send verification email; please check email address')
  end

  def html_email
    <<~END_EMAIL
      <H1>Rewards Registration Received</H1>
      <p>Click <a href=\"#{@registration[:verification_url]}\">here</a>
      to complete account registration.
      <p>
    END_EMAIL
  end

  def mail_json
    {
      personalizations: [{ to: [{ 'email' => @registration[:email] }] }],
      from: { 'email' => from_email },
      subject: 'Rewards Registration Verification',
      content: [{ type: 'text/html', value: html_email }]
    }
  end

  def from_email
    ENV['SENDGRID_FROM_EMAIL'] || 'Rewards <noreply@rewards.app>'
  end

  def mail_api_key
    ENV['SENDGRID_API_KEY']
  end

  def mail_url
    ENV['SENDGRID_API_URL']
  end
end
