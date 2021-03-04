require 'spec_helper'

test_public_key = "FLWPUBK-xxxxxxxxxxxxxxxxxxxxx-X" 
test_secret_key = "FLWSECK-xxxxxxxxxxxxxxxxxxxxx-X"
test_encryption_key = "611d0eda25a3c931863d92c4"

invalid_test_public_key = "xxxxxxxxxxxxxxxxxxxxx-X" 
invalid_test_secret_key = "xxxxxxxxxxxxxxxxxxxxx-X"

Rspec.describe Flutterwave do

flutterwave = Flutterwave.new(test_public_key, test_secret_key, test_encryption_key)
it "should return the valid flutterwave object" do
  expect(flutterwave.nil?).to eq(false)
end

it "should return valid public key" do
  expect(flutterwave.public_key[0..7]).to eq("FLWPUBK-") || expect(flutterwave.public_key[0..11]).to eq("FLWPUBK_TEST") 
end

it "should return valid secret key" do
  expect(flutterwave.secret_key[0..7]).to eq("FLWSECK-") || expect(flutterwave.secret_key[0..11]).to eq("FLWSECK_TEST") 
end

it 'should raise Error if invalid public key set' do
  begin
    flutterwave_pub_key_error = Flutterwave.new(invalid_test_public_key, test_secret_key)
  rescue  => e
    expect(e.instance_of? FlutterwaveBadKeyError).to eq true
  end
end

end
