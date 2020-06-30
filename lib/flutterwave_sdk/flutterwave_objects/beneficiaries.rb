require_relative "base/base.rb"
require 'json'

class Beneficiaries < Base

    def create_beneficiary(data)
        base_url = flutterwave_object.base_url 
        required_parameters = ["account_number", "account_bank"]
        check_passed_parameters(required_parameters, data)
        payload = data.to_json
        response = post_request("#{base_url}/beneficiaries", payload) 
        return response
    end

    def list_beneficiaries
        base_url = flutterwave_object.base_url 
        response = get_request("#{base_url}/beneficiaries")
        return response
    end

    def fetch_beneficiary(id)
        base_url = flutterwave_object.base_url 
        response = get_request("#{base_url}/beneficiaries/#{id}")
        return response
    end

    def delete_beneficiary(id)
        base_url = flutterwave_object.base_url 
        payload = {}
        payload = payload.to_json
        response = delete_request("#{base_url}/beneficiaries/#{id}", payload)
        return response
    end
end