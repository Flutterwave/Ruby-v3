require_relative "flutterwave_sdk/version"
require_relative "flutterwave_sdk/flutterwave_modules/base_endpoints"
require_relative "flutterwave_sdk/flutterwave_objects/base/base"
require_relative "flutterwave_sdk/flutterwave_modules/util"
require_relative "flutterwave_sdk/flutterwave_objects/card"
require_relative "flutterwave_sdk/flutterwave_objects/mobile_money"
require_relative "flutterwave_sdk/flutterwave_objects/account_payment"
require_relative "flutterwave_sdk/flutterwave_objects/bank_transfer"
require_relative "flutterwave_sdk/flutterwave_objects/ussd_payment"
require_relative "flutterwave_sdk/flutterwave_objects/qr"
require_relative "flutterwave_sdk/flutterwave_objects/tokenized_charge"
require_relative "flutterwave_sdk/flutterwave_objects/transactions"
require_relative "flutterwave_sdk/flutterwave_objects/transfer"
require_relative "flutterwave_sdk/flutterwave_objects/bank"
require_relative "flutterwave_sdk/flutterwave_objects/misc"
require_relative "flutterwave_sdk/flutterwave_objects/payment_plan"
require_relative "flutterwave_sdk/flutterwave_objects/beneficiaries"
require_relative "flutterwave_sdk/flutterwave_objects/subscriptions"
require_relative "flutterwave_sdk/flutterwave_objects/virtual_card"
require_relative "flutterwave_sdk/flutterwave_objects/subaccount"
require_relative "flutterwave_sdk/flutterwave_objects/settlements"
require_relative "flutterwave_sdk/flutterwave_objects/otp"
require_relative "flutterwave_sdk/flutterwave_objects/virtual_account_number"
require_relative "flutterwave_sdk/flutterwave_objects/bills"
require_relative "flutterwave_sdk/flutterwave_objects/preauthorise"
require_relative "flutterwave_sdk/error"

class Flutterwave

  attr_accessor :public_key, :secret_key, :encryption_key, :production, :url

        # method to initialize flutterwave object
  def initialize(public_key=nil, secret_key=nil, encryption_key=nil, production=false)
    @public_key = public_key
    @secret_key = secret_key
    @production = production
    @encryption_key = encryption_key
    flutterwave_sandbox_url = BASE_ENDPOINTS::FLUTTERWAVE_SANDBOX_URL
    flutterwave_live_url = BASE_ENDPOINTS::FLUTTERWAVE_LIVE_URL

    # set rave url to sandbox or live if we are in production or development
    if production == false
        @url =  flutterwave_sandbox_url
    else
        @url = flutterwave_live_url
    end

  def base_url
  return url
  end

   # check if we set our public , secret  and encryption keys to the environment variable
   if (public_key.nil?)
    @public_key = ENV['FLUTTERWAVE_PUBLIC_KEY']
   else 
    @public_key = public_key
   end

   if (secret_key.nil?)
    @secret_key = ENV['FLUTTERWAVE_SECRET_KEY']
   else
    @secret_key = secret_key
   end

   if (encryption_key.nil?)
    @encryption_key = ENV['FLUTTERWAVE_ENCRYPTION_KEY']
   else
    @encryption_key = encryption_key
   end
    warn "Warning: To ensure your rave account api keys are safe, It is best to always set your keys in the environment variable"

  # raise this error if no public key is passed
  unless !@public_key.nil?
    raise FlutterwaveBadKeyError, "No public key supplied and couldn't find any in environment variables. Make sure to set public key as an environment variable FLUTTERWAVE_PUBLIC_KEY"
  end
  # raise this error if invalid public key is passed
  unless @public_key[0..7] == 'FLWPUBK-' || @public_key[0..11] == 'FLWPUBK_TEST'
    raise FlutterwaveBadKeyError, "Invalid public key #{@public_key}"
  end
  
  # raise this error if no secret key is passed
  unless !@secret_key.nil?
    raise FlutterwaveBadKeyError, "No secret key supplied and couldn't find any in environment variables. Make sure to set secret key as an environment variable FLUTTERWAVE_SECRET_KEY"
  end
  # raise this error if invalid secret key is passed
  unless @secret_key[0..7] == 'FLWSECK-' || @secret_key[0..11] == 'FLWSECK_TEST'
    raise FlutterwaveBadKeyError, "Invalid secret key #{@secret_key}"
  end

  # raise this error if no encryption key is passed
  unless !@encryption_key.nil?
    raise FlutterwaveBadKeyError, "No encryption key supplied and couldn't find any in environment variables. Make sure to set encryption key as an environment variable FLUTTERWAVE_ENCRYPTION_KEY"
  end
end

  #tracking activities
  def flutterwave_tracking 
    endpoint = "https://kgelfdz7mf.execute-api.us-east-1.amazonaws.com/staging/sendevent"
      public_key = @public_key
          
          
        payload = {
          "PBFPubKey" => public_key,
          "language" => "Ruby",
          "version" => "1.0",
          "title" => "test message",
          "message" => "test is done"
          }
          data = payload.to_json
  
          response = HTTParty.post(endpoint, {
            body: data,
            headers: {
              'Content-Type' => 'application/json'
            }
          })
    
          unless (response.code == 200 || response.code == 201)
            raise RaveServerError.new(response), "HTTP Code #{response.code}: #{response.body}"
          end 
          return response
    end

end


