require_relative "base/base.rb"
require 'json'

class VirtualCard < Base

    def create_virtual_card(data)
        base_url = flutterwave_object.base_url 
        required_parameters = ["currency", "amount", "billing_name"]
        check_passed_parameters(required_parameters, data)
        payload = data.to_json
        response = post_request("#{base_url}/virtual-cards", payload) 
        return response
    end

    def get_all_virtual_cards
        base_url = flutterwave_object.base_url 
        response = get_request("#{base_url}/virtual-cards")
        return response
    end

    def get_virtual_card(id)
        base_url = flutterwave_object.base_url 
        response = get_request("#{base_url}/virtual-cards/#{id}")
        return response
    end

    def fund_virtual_card(id, data)
        base_url = flutterwave_object.base_url 
        required_parameters = [ "amount"]
        check_passed_parameters(required_parameters, data)
        payload = data.to_json
        response = post_request("#{base_url}/virtual-cards/#{id}/fund", payload) 
        return response
    end

    def terminate_virtual_card(id)
        base_url = flutterwave_object.base_url 
        payload = {}
        payload = payload.to_json
        response = put_request("#{base_url}/virtual-cards/#{id}/terminate", payload) 
        return response
    end

    def get_virtual_card_transactions(id, from, to, index, size)
        base_url = flutterwave_object.base_url 
        response = get_request("#{base_url}/virtual-cards/#{id}/transactions", {"from" => from, "to" => to, "index" => index, "size" => size})
        return response
    end

    def withdraw_from_virtual_card(id, data)
        base_url = flutterwave_object.base_url 
        required_parameters = [ "amount"]
        check_passed_parameters(required_parameters, data)
        payload = data.to_json
        response = post_request("#{base_url}/virtual-cards/#{id}/withdraw", payload) 
        return response
    end

    def block_unblock_virtual_card(id, status_action)
        base_url = flutterwave_object.base_url 
        payload = {}
        payload = payload.to_json
        response = put_request("#{base_url}/virtual-cards/#{id}/status/#{status_action}", payload) 
        return response
    end
end