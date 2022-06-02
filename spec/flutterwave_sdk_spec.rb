require 'spec_helper'

test_public_key = ENV['TEST_PUBLIC_KEY']
test_secret_key = ENV['TEST_SECRET_KEY']
test_encryption_key = ENV['TEST_ENCRYPTION_KEY']

invalid_test_public_key =  ENV['INVALID_PUBLIC_TEST']
invalid_test_secret_key =  ENV['INVALID_SECRET_TEST']

RSpec.describe Flutterwave do

flutterwave = Flutterwave.new(test_public_key, test_secret_key, test_encryption_key)
it "should return the valid flutterwave object" do
  expect(flutterwave.nil?).to eq(false)
end

# it "should return valid public key" do
#   expect(flutterwave.public_key[0..7]).to eq("FLWPUBK-") || expect(flutterwave.public_key[0..11]).to eq("FLWPUBK_TEST") 
# end

# it "should return valid secret key" do
#   expect(flutterwave.secret_key[0..7]).to eq("FLWSECK-") || expect(flutterwave.secret_key[0..11]).to eq("FLWSECK_TEST") 
# end

it "should return valid public key" do
  expect(flutterwave.public_key[0..11]).to eq("FLWPUBK_TEST") 
end

it "should return valid secret key" do
  expect(flutterwave.secret_key[0..11]).to eq("FLWSECK_TEST") 
end

it 'should raise Error if invalid public key set' do
  begin
    flutterwave_pub_key_error = Flutterwave.new(invalid_test_public_key, test_secret_key)
  rescue  => e
    expect(e.instance_of? FlutterwaveBadKeyError).to eq true
  end
end

end
