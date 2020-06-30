require_relative "base/base.rb"
require 'json'

class PaymentPlan < Base

    # method to create a payment plan
    def create_payment_plan(data)
        base_url = flutterwave_object.base_url 
        required_parameters = ["amount", "name", "interval"]
        check_passed_parameters(required_parameters, data)
        payload = data.to_json
        response = post_request("#{base_url}/payment-plans", payload) 
        return response
    end 

    def get_payment_plans
        base_url = flutterwave_object.base_url 
        response = get_request("#{base_url}/payment-plans")
        return response
    end 

    def get_a_payment_plan(id)
        base_url = flutterwave_object.base_url 
        response = get_request("#{base_url}/payment-plans/#{id}")
        return response
    end 

    def update_payment_plan(id, data)
        base_url = flutterwave_object.base_url 
        payload = data.to_json
        response = put_request("#{base_url}/payment-plans/#{id}",payload)
        return response
    end

    def cancel_payment_plan(id)
        base_url = flutterwave_object.base_url
        payload = {}
        payload = payload.to_json
        response = put_request("#{base_url}/payment-plans/#{id}/cancel",payload)
        return response
    end
end