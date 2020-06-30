require_relative "base/base.rb"
require 'json'

class Subaccount < Base
    def create_subaccount(data)
        base_url = flutterwave_object.base_url 
        required_parameters = ["account_bank", "account_number", "business_name", "business_contact", "country", "split_value", "business_mobile"]
        check_passed_parameters(required_parameters, data)
        payload = data.to_json
        response = post_request("#{base_url}/subaccounts", payload) 
        return response
    end

    def fetch_subaccounts
        base_url = flutterwave_object.base_url 
        response = get_request("#{base_url}/subaccounts") 
        return response
    end

    def fetch_subaccount(id)
        base_url = flutterwave_object.base_url 
        response = get_request("#{base_url}/subaccounts/#{id}") 
        return response
    end

    def update_subaccount(id, data)
        base_url = flutterwave_object.base_url 
        payload = data.to_json
        response = put_request("#{base_url}/subaccounts/#{id}", payload)
        return response
    end

    def delete_subaccount(id)
        base_url = flutterwave_object.base_url 
        payload = {}
        payload = payload.to_json
        response = delete_request("#{base_url}/subaccounts/#{id}", payload) 
        return response
    end
end