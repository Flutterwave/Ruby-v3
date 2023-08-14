require 'dotenv'
require 'spec_helper'
require "flutterwave_sdk/flutterwave_objects/uk_and_eu_account"

Dotenv.load

test_public_key = ENV['TEST_PUBLIC_KEY']
test_secret_key = ENV['TEST_SECRET_KEY']
test_encryption_key = ENV['TEST_ENCRYPTION_KEY']

payload = {
  "tx_ref"=> "MC-" + Date.today.to_s,
  "amount"=>"10",
  "currency"=>"USD",
  "email"=> "ifunanyaikemma@gmail.com",
  "fullname"=> "Yolande Aglaé Colbert",
  "narration"=>"Test payment",
  "redirect_url"=>"http=>//localhost=>9000/dump",
  "client_ip"=>"192.168.0.1",
  "device_fingerprint"=>"gdgdhdh738bhshsjs",
  "billing_zip"=>"15101",
  "billing_city"=>"allison park",
  "billing_address"=>"3563 Huntertown Rd",
  "billing_state"=>"Pennsylvania",
  "billing_country"=>"US",
  "phone_number"=>"09012345678",
  "meta"=>{
     "metaname"=>"testmeta",
     "metavalue"=>"testvalue"
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

RSpec.describe ApplePayment do
  flutterwave = Flutterwave.new(test_public_key, test_secret_key, test_encryption_key)
  payment = ApplePayment.new(flutterwave)
  payment_charge = payment.initiate_charge(payload)


  context "when a merchant tries to charge a customers via apple pay" do
      it "should return a apple pay payment object" do
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
          expect(payload_response["data"]["meta"]["authorization"]["mode"]).to eq("redirect")
      end

      it 'should successfully return processor response ' do
        payload_response = payment_charge
          expect(payload_response["data"]["processor_response"]).to eq("Pending validation")
      end

      it 'should successfully return the auth model' do
          payload_response = payment_charge
          expect(payload_response["data"]["auth_model"]).to eq("APPLEPAY")
      end

  end
end
