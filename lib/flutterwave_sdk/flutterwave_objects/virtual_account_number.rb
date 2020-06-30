require_relative "base/base.rb"
require 'json'

class VirtualAccountNumber < Base

    def create_virtual_account_number(data)
        base_url = flutterwave_object.base_url 
        required_parameters = ["email", "duration", "frequency", "tx_ref"]
        check_passed_parameters(required_parameters, data)
        payload = data.to_json
        response = post_request("#{base_url}/virtual-account-numbers", payload) 
        return response
    end

    def create_bulk_virtual_account_number(data)
        base_url = flutterwave_object.base_url 
        payload = data.to_json
        response = post_request("#{base_url}/bulk-virtual-account-numbers", payload) 
        return response
    end

    def get_bulk_virtual_account_number(batch_id)
        base_url = flutterwave_object.base_url 
        response = get_request("#{base_url}/bulk-virtual-account-numbers/#{batch_id}") 
        return response
    end

    def get_virtual_account_number(order_ref)
        base_url = flutterwave_object.base_url 
        response = get_request("#{base_url}/virtual-account-numbers/#{order_ref}") 
        return response
    end

end