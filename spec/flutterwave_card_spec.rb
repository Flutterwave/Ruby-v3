require 'spec_helper'
require "flutterwave_sdk/flutterwave_objects/card"

test_public_key = "FLWPUBK-xxxxxxxxxxxxxxxxxxxxx-X" 
test_secret_key = "FLWSECK-xxxxxxxxxxxxxxxxxxxxx-X"
test_encryption_key = "xxxxxxxxxxxxxxxxxxxxx"


payload = {
    "type" => "card",
    "card_number" => "5531886652142950",
    "cvv" => "564",
    "expiry_month" => "09",
    "expiry_year" => "22",
    "currency" => "NGN",
    "amount" => "10",
    "email" => "ifunanyaikemma@gmail.com",
    "fullname" => "Ifunanya ikemma",
    "tx_ref" => "MC-3243e-if-12",
    "redirect_url" => "https://webhook.site/3ed41e38-2c79-4c79-b455-97398730866c"
}

pin_payload =   {    
    "type" => "card",
    "card_number" => "5531886652142950",
    "cvv" => "564",
    "expiry_month" => "09",
    "expiry_year" => "22",
    "currency" => "NGN",
    "amount" => "10",
    "email" => "ifunanyaikemma@gmail.com",
    "fullname" => "Ifunanya ikemma",
    "tx_ref" => "MC-3243e-if-12",
    "redirect_url" => "https://webhook.site/3ed41e38-2c79-4c79-b455-97398730866c",
    "authorization": {
    "mode": "pin",
    "pin": "3310",
                    }
                }

incomplete_card_payload = {
    "type" => "card",
    # "card_number" => "5531886652142950",
    "cvv" => "564",
    "expiry_month" => "09",
    "expiry_year" => "22",
    "currency" => "NGN",
    "amount" => "10",
    "email" => "ifunanyaikemma@gmail.com",
    "fullname" => "Ifunanya ikemma",
    "tx_ref" => "MC-3243e-if-12",
    "redirect_url" => "https://webhook.site/3ed41e38-2c79-4c79-b455-97398730866c"
}

Rspec.describe Card do
    flutterwave = Flutterwave.new(test_public_key, test_secret_key, test_encryption_key)
    card = Card.new(flutterwave)

    context "when a merchant tries to charge a customers card" do
        it "should return a card object" do
          expect(card.nil?).to eq(false)
        end

        it 'should raise Error if card payload is incomplete' do
            begin
              incomplete_card_payload_response = card.initiate_charge(incomplete_card_payload)
            rescue  => e
              expect(e.instance_of? IncompleteParameterError).to eq true
            end
          end

          it 'should check if authentication is required after charging a card' do
            first_payload_response = card.initiate_charge(payload)
            expect(first_payload_response["meta"]["authorization"]["mode"].nil?).to eq(false)
          end

          it 'should successfully charge card with suggested auth PIN' do
            second_payload_response = card.initiate_charge(pin_payload)
            expect(second_payload_response["data"]["status"]).to eq("pending")
          end

          it 'should return chargeResponseCode 00 after successfully validating with flwRef and OTP' do
            card_initiate_response = card.initiate_charge(pin_payload)
            card_validate_response = card.validate_charge(card_initiate_response["data"]["flw_ref"], "12345")
            expect(card_validate_response["data"]["processor_response"]).to eq("successful")
          end

          it 'should return chargecode 00 after successfully verifying a card transaction with txRef' do
            card_initiate_response = card.initiate_charge(pin_payload)
            card_validate_response = card.validate_charge(card_initiate_response["data"]["flw_ref"], "12345")
            card_verify_response = card.verify_charge(card_validate_response["data"]["id"])
            expect(card_verify_response["data"]["processor_response"]).to eq("successful")
          end
end
end
