require_relative "base/base.rb"
require 'json'

class Subscriptions < Base

    def get_all_subscriptions
        base_url = flutterwave_object.base_url 
        response = get_request("#{base_url}/subscriptions")
        return response
    end

    def cancel_subscription(id)
        base_url = flutterwave_object.base_url
        payload = {}
        payload = payload.to_json
        response = put_request("#{base_url}/subscriptions/#{id}/cancel", payload) 
    end

    def activate_subscription(id)
        base_url = flutterwave_object.base_url
        payload = {}
        payload = payload.to_json
        response = put_request("#{base_url}/subscriptions/#{id}/activate", payload) 
    end
end