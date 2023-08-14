require 'dotenv'
require 'spec_helper'
require "flutterwave_sdk/flutterwave_objects/uk_and_eu_account"

Dotenv.load

test_public_key = ENV['TEST_PUBLIC_KEY']
test_secret_key = ENV['TEST_SECRET_KEY']
test_encryption_key = ENV['TEST_ENCRYPTION_KEY']

payload = {
    "amount"=> "10",
    "email"=> "ifunanyaikemma@gmail.com",
    "currency"=> "EGP",
    "phone_number"=> "09012345678",
    "redirect_url"=> "https=>//www.flutterwave.com",
    "meta"=> {
        "name"=> "Ifunanya",
        "tools"=> "Postman"
    }
}

incomplete_payload = {
  "amount" => "10",
  "email" => "ifunanyaikemma@gmail.com",
  "tx_ref" => "MC-#{Time.now.to_i}",
}

invalid_currency_payload = {
  "amount" => "100",
  "email" => "ifunanyaikemma@gmail.com",
  "tx_ref" => "MC-#{Time.now.to_i}",
  "currency" => "NGN",
}

RSpec.describe FawryPayment do
  flutterwave = Flutterwave.new(test_public_key, test_secret_key, test_encryption_key)
  payment = FawryPayment.new(flutterwave)
  payment_charge = payment.initiate_charge(payload)


  context "when a merchant tries to charge a customers via fawry pay" do
      it "should return a fawry pay payment object" do
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
          expect(payload_response["data"]["currency"]).to eq("EGP")
          expect(payload_response["meta"]["authorization"]["mode"]).to eq("fawry_pay")
          expect(payload_response["meta"]["authorization"]["instruction"]).to eq("Please make payment with the flw_ref returned in the response which should be the same as the reference sent via SMS")
      end

      it 'should successfully return processor response ' do
        payload_response = payment_charge
          expect(payload_response["data"]["processor_response"]).to eq("Request is pending")
      end

      it 'should successfully return the payment type' do
          payload_response = payment_charge
          expect(payload_response["data"]["payment_type"]).to eq("fawry_pay")
      end

  end
end
