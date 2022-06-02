require_relative "base/base.rb"
require 'json'

class AccountPayment < Base
    def initiate_charge(data)
        base_url = flutterwave_object.base_url
        
        # only update the payload with the transaction reference if it isn't already added to the payload
        if !data.key?("tx_ref")
            data.merge!({"tx_ref" => Util.transaction_reference_generator})
        end
        # check the currency to determine the type and the required parameters 
        currency = data["currency"]
        if currency == "NGN"
            required_parameters =  [ "amount", "email", "account_bank", "account_number", "tx_ref", "currency"]
            type = "debit_ng_account"
        elsif currency  == "GBP"
            required_parameters =  [ "amount", "email", "account_bank", "account_number", "tx_ref", "currency"]
            type = "debit_uk_account"
        elsif currency == "USD" || currency == "ZAR"
            required_parameters = [ "amount", "email", "country", "tx_ref", "currency"]
            type = "ach_payment"
        else
            return "pass a valid currency"
        end

        check_passed_parameters(required_parameters, data)
        type = type
        payload = data.to_json

        response = post_request("#{base_url}#{BASE_ENDPOINTS::CHARGE_ENDPOINT}?type=#{type}", payload) 
        return response
    end

    def validate_charge(flw_ref, otp) 
        base_url = flutterwave_object.base_url       
        
        payload = {
            "otp" => otp,
            "flw_ref" => flw_ref
        }

        payload = payload.to_json

        response = post_request("#{base_url}/validate-charge", payload)
        return response
    end

    def verify_charge(id)
        base_url = flutterwave_object.base_url

        response = get_request("#{base_url}/transactions/#{id}/verify")
        return response
    end
end