require 'dotenv'
require 'spec_helper'
require "flutterwave_sdk/flutterwave_objects/mobile_money"
require "flutterwave_sdk/flutterwave_objects/transactions"

Dotenv.load

test_public_key = ENV['TEST_PUBLIC_KEY']
test_secret_key = ENV['TEST_SECRET_KEY']
test_encryption_key = ENV['TEST_ENCRYPTION_KEY']

payload = {
 "tx_ref" => "MC-" + + Date.today.to_s,
  "amount" => "100",
  "currency" => "TZS",
  "email" => "ifunanyaikemma@gmail.com",
  "phone_number" => "0782835136",
  "fullname" => "Yolande Aglae Colbert",
  "network" => "Halopesa",
}

incomplete_payload = {
  "tx_ref" => "MC-158523sdsdsd",
  "amount" => "100",
  "currency" => "TZS",
  "email" => "ifunanyaikemma@gmail.com",
}

RSpec.describe MobileMoney do
  flutterwave = Flutterwave.new(test_public_key, test_secret_key, test_encryption_key)
  mobile_money = MobileMoney.new(flutterwave)
  transactions = Transactions.new(flutterwave)
  mobile_money_charge = mobile_money.initiate_charge(payload)


  context "when a merchant tries to charge a customers via mobile money" do
      it "should return a mobile money object" do
        expect(mobile_money.nil?).to eq(false)
      end

      it 'should raise Error if the mobile money payload is incomplete' do
          begin
            incomplete_mobile_money_response = mobile_money.initiate_charge(incomplete_payload)
          rescue  => e
            expect(e.instance_of? IncompleteParameterError).to eq true
          end
        end

      it 'should successfully generate payment link for the charge' do
          payload_response = mobile_money_charge
          expect(payload_response["status"]).to eq("success")
      end

      it 'should successfully return processor response ' do
        payload_response = mobile_money_charge
          expect(payload_response["data"]["processor_response"]).to eq("Transaction in progress")
      end

      it 'should successfully return the auth model' do
          payload_response = mobile_money_charge
          expect(payload_response["data"]["auth_model"]).to eq("MOBILEMONEY")
      end

      it 'should successfully verify fees for mobile money payments' do
          currency = "TZS"
          amount = "100"
          verify_fee_response = transactions.transaction_fee(currency, amount)
          expect(verify_fee_response["data"]["fee"]).to eq(1.4)
      end

  end
end
