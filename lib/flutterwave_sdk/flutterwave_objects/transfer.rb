require_relative "base/base.rb"
require 'json'

class Transfer < Base

    def transfer_fee(currency,amount)
        base_url = flutterwave_object.base_url
        response = get_request("#{base_url}/transfers/fee?currency=#{currency}&amount=#{amount}")
        return response
    end

    def initiate_transfer(data)
        base_url = flutterwave_object.base_url      
        # only update the payload with the transaction reference if it isn't already added to the payload
        if !data.key?("tx_ref")
            data.merge!({"tx_ref" => Util.transaction_reference_generator})
        end

        required_parameters = ["amount", "currency", "account_bank", "account_number"]
        check_passed_parameters(required_parameters, data)
        payload = data.to_json
        response = post_request("#{base_url}/transfers", payload)
        return response
    end

    def initiate_bulk_transfer(data)
        base_url = flutterwave_object.base_url 
        required_parameters = ["title", "bulk_data"]
        check_passed_parameters(required_parameters, data)   
        payload = data.to_json
        response = post_request("#{base_url}/bulk-transfers", payload) 
        return response
    end

    def get_all_transfers
        base_url = flutterwave_object.base_url
        response = get_request("#{base_url}/transfers")
        return response
    end

    def get_a_transfer(id)
        base_url = flutterwave_object.base_url
        response = get_request("#{base_url}/transfers/#{id}")
        return response
    end
end