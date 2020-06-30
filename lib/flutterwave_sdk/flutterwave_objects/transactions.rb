require_relative "base/base.rb"
require 'json'

class Transactions < Base
    def transaction_fee(currency, amount)
        base_url = flutterwave_object.base_url
        required_parameters = ["amount", "currency"]
        check_passed_parameters(required_parameters, data)
        response = get_request("#{base_url}/transactions/fee?&amount=#{amount}&currency=#{currency}")
        return response
    end

    def get_transactions
        base_url = flutterwave_object.base_url 
        response = get_request("#{base_url}/transactions")
        return response

    end

    def verify_transaction(id)
        base_url = flutterwave_object.base_url
        response = get_request("#{base_url}/transactions/#{id}/verify")
        return response
    end

    def transactions_events(id)
        base_url = flutterwave_object.base_url 
        response = get_request("#{base_url}/transactions/#{id}/events")
        return response
    end

    def initiate_a_refund(data, id)
        base_url = flutterwave_object.base_url 
        payload = data.to_json
        response = post_request("#{base_url}/transactions/#{id}/refund", payload)
        return response
    end

    #resend transaction webhook

    def resend_transaction_webhook(payload)
        base_url = flutterwave_object.base_url 
        response = post_request("#{base_url}/transactions/resend-hook", payload.to_json)
        return response
    end

end