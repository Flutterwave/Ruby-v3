require_relative "base/base.rb"
require 'json'

class TokenizedCharge < Base

    # method to charge with token 
    def tokenized_charge(data)
        base_url = flutterwave_object.base_url 
        # only update the payload with the transaction reference if it isn't already added to the payload
        if !data.key?("tx_ref")
            data.merge!({"tx_ref" => Util.transaction_reference_generator})
        end

        required_parameters = [ "token", "currency", "country", "amount", "tx_ref", "email"]
        check_passed_parameters(required_parameters, data)

        response = post_request("#{base_url}/tokenized-charges", data.to_json) 
 
        return response

    end

    def verify_tokenized_charge(id)
        base_url = flutterwave_object.base_url 
        response = get_request("#{base_url}/transactions/#{id}/verify")
        return response
    end

    # method for updating token detials
    def update_token(data, token)
        base_url = flutterwave_object.base_url 
        response = put_request("#{base_url}/tokens/#{token}", data.to_json)
        return response
    end

    # method to create bulk tokenized charges
    def bulk_tokenized_charge(data)
        base_url = flutterwave_object.base_url 
        required_parameters = ["title", "retry_strategy", "bulk_data"]
        check_passed_parameters(required_parameters, data)

        payload = data.to_json

        response = post_request("#{base_url}/bulk-tokenized-charges/", payload)
        return response
    end

    #method to get status of a bulk tokenized charges
    def bulk_tokenized_charge_status(bulk_id)
        base_url = flutterwave_object.base_url 
        response = get_request("#{base_url}/bulk-tokenized-charges/#{bulk_id}")
        return response
    end

    #method to get all the bulk tokenized transactions
    def bulk_tokenized_charge_transactions(bulk_id)
        base_url = flutterwave_object.base_url 
        response = get_request("#{base_url}/bulk-tokenized-charges/#{bulk_id}/transactions")
        return response
    end
end