require 'dotenv'
require 'spec_helper'
require "flutterwave_sdk/flutterwave_objects/uk_and_eu_account"

Dotenv.load

test_public_key = ENV['TEST_PUBLIC_KEY']
test_secret_key = ENV['TEST_SECRET_KEY']
test_encryption_key = ENV['TEST_ENCRYPTION_KEY']

payload = {
 "amount" => "100",
  "email" => "ifunanyaikemma@gmail.com",
  "tx_ref" => "MC-#{Time.now.to_i}",
  "currency" => "GBP",
  "is_token_io" => 1
}

incomplete_payload = {
  "amount" => "100",
  "email" => "ifunanyaikemma@gmail.com",
  "tx_ref" => "MC-#{Time.now.to_i}",
  "currency" => "GBP",
}

invalid_currency_payload = {
  "amount" => "100",
  "email" => "ifunanyaikemma@gmail.com",
  "tx_ref" => "MC-#{Time.now.to_i}",
  "currency" => "NGN",
  "is_token_io" => 1
}

RSpec.describe UkPayment do
  flutterwave = Flutterwave.new(test_public_key, test_secret_key, test_encryption_key)
  payment = UkPayment.new(flutterwave)
  payment_charge = payment.initiate_charge(payload)


  context "when a merchant tries to charge a customers via mobile money" do
      it "should return a ach payment object" do
        expect(payment.nil?).to eq(false)
      end

      it 'should raise Error if the ach payload is incomplete' do
          begin
            incomplete_payment_response = payment.initiate_charge(incomplete_payload)
          rescue  => e
            expect(e.instance_of? IncompleteParameterError).to eq true
          end
        end

      it 'should successfully initate payment and return authorization mode for the charge' do
          payload_response = payment_charge
          expect(payload_response["data"]["status"]).to eq("pending")
          expect(payload_response["message"]).to eq("Charge initiated")
          expect(payload_response["meta"]["authorization"]["mode"]).to eq("redirect")
      end

      it 'should successfully return processor response ' do
        payload_response = payment_charge
          expect(payload_response["data"]["processor_response"]).to eq("Transaction is pending authentication")
      end

      it 'should successfully return the auth model' do
          payload_response = payment_charge
          expect(payload_response["data"]["auth_model"]).to eq("TOKEN")
      end

  end
end
