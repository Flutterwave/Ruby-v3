require_relative "base/card_base.rb"
require 'json'

class Card < CardBase

    # method to initiate card charge
    def initiate_charge(data)
        base_url = flutterwave_object.base_url
        encryption_key = flutterwave_object.encryption_key
        public_key = flutterwave_object.public_key

        # only update the payload with the transaction reference if it isn't already added to the payload
        if !data.key?("tx_ref")
            data.merge!({"tx_ref" => Util.transaction_reference_generator})
        end

        data.merge!({"public_key" => public_key})

            required_parameters = [ "card_number", "cvv", "expiry_month", "expiry_year", "amount", "tx_ref", "currency", "email"]
        check_passed_parameters(required_parameters, data)

        encrypt_data = Util.encrypt(encryption_key, data)

        payload = {
            "public_key" => public_key,
            "client" => encrypt_data,
            "alg" => "3DES-24"
        }
        type = "card"
        payload = payload.to_json

        response = post_request("#{base_url}#{BASE_ENDPOINTS::CHARGE_ENDPOINT}?type=#{type}", payload)

        return response

    end

    def validate_charge(flw_ref, otp)
        base_url = flutterwave_object.base_url
        payload = {
            "otp" => otp,
            "flw_ref" => flw_ref
        }

        payload = payload.to_json
        response = post_request("#{base_url}/validate-charge", payload)
        return response
    end

    def verify_charge(id)
        base_url = flutterwave_object.base_url
        response = get_request("#{base_url}/transactions/#{id}/verify")
        return response
    end
end
