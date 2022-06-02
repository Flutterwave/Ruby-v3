require 'dotenv'
require 'spec_helper'
require "flutterwave_sdk/flutterwave_objects/mobile_money"
require "flutterwave_sdk/flutterwave_objects/transactions"

Dotenv.load

test_public_key = ENV['TEST_PUBLIC_KEY']
test_secret_key = ENV['TEST_SECRET_KEY']
test_encryption_key = ENV['TEST_ENCRYPTION_KEY']

payload = {
    "tx_ref" => "Sample_RBRef154",
    "amount" => "50",
    "currency" => "GHS",
    "network" => "MTN",
    "email" => "developers@flutterwavego.com",
    "phone_number" => "054709929220",
    "fullname" => "Flutterwave Developers",
    "client_ip" => "154.123.220.1",
    "device_fingerprint" => "62wd23423rq32dskd4323qew1"
    
}

incomplete_payload = {
    "tx_ref" => "Sample_RBRef131",
    "amount" => "50",
    "currency" => "GHS",
    # "email" => "developers@flutterwavego.com",
    "phone_number" => "054709929220",
    "fullname" => "John Madakin",
    "client_ip" => "Flutterwave Developers",
    "device_fingerprint" => "62wd23423rq32dskd4323qew1"
    
}

momo_id = 3440004


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

        it 'should successfully verify mobile money payment' do
            verify_response = mobile_money.verify_charge(momo_id)
            expect(verify_response["data"]["processor_response"]).to eq("Approved")
        end

        it 'should successfully verify fees for mobile money payments' do
            currency = "GHS"
            amount = "5000"
            verify_fee_response = transactions.transaction_fee(currency, amount)
            expect(verify_fee_response["data"]["fee"]).to eq(70)
        end

    end
end