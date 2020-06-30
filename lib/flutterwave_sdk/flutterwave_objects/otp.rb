require_relative "base/base.rb"
require 'json'

class OTP < Base
    def create_otp(data)
        base_url = flutterwave_object.base_url 
        required_parameters = ["length", "customer", "sender", "send", "medium"]
        check_passed_parameters(required_parameters, data)
        payload = data.to_json
        response = post_request("#{base_url}/otps", payload) 
        return response
    end

    def validate_otp(reference, data)
        base_url = flutterwave_object.base_url 
        required_parameters = ["otp"]
        check_passed_parameters(required_parameters, data)
        payload = data.to_json
        response = post_request("#{base_url}/otps/#{reference}/validate", payload) 
        return response
    end
end