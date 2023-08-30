require_relative "base/base.rb"
require 'json'

class UkPayment < Base
    def initiate_charge(data)
        base_url = flutterwave_object.base_url

        # only update the payload with the transaction reference if it isn't already added to the payload
        if !data.key?("tx_ref")
            data.merge!({"tx_ref" => Util.transaction_reference_generator})
        end
        # check the currency to determine the type and the required parameters
        currency = data["currency"]
        if currency == "GBP"
            required_parameters =  [ "amount", "email",  "tx_ref", "currency", "is_token_io"]
            type = "account-ach-uk"
        elsif currency  == "EUR"
            required_parameters =  [ "amount", "email", "tx_ref", "currency", "is_token_io"]
            type = "account-ach-uk"
        else
            return "pass a valid currency"
        end

        check_passed_parameters(required_parameters, data)
        type = type
        payload = data.to_json

        response = post_request("#{base_url}#{BASE_ENDPOINTS::CHARGE_ENDPOINT}?type=#{type}", payload)
        return response
    end

    def verify_charge(id)
        base_url = flutterwave_object.base_url

        response = get_request("#{base_url}/transactions/#{id}/verify")
        return response
    end
end
