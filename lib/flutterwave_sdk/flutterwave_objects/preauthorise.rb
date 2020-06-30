require_relative "base/base.rb"
require 'json'

class Preauth < Base

    def capture_preauth(flw_ref, data)
        base_url = flutterwave_object.base_url 
        payload = data.to_json
        response = post_request("#{base_url}/charges/#{flw_ref}/capture", payload) 
        return response
    end

    def void_preauth(flw_ref)
        base_url = flutterwave_object.base_url 
        payload = payload.to_json
        response = post_request("#{base_url}/charges/#{flw_ref}/void", payload) 
        return response
    end

    def refund_preauth(flw_ref, data)
        base_url = flutterwave_object.base_url 
        payload = data.to_json
        response = post_request("#{base_url}/charges/#{flw_ref}/refund", payload) 
        return response
    end
end