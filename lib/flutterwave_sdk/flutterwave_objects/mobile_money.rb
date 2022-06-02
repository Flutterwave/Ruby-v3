require_relative "base/base.rb"
require 'json'

class MobileMoney < Base
    def initiate_charge(data)
        base_url = flutterwave_object.base_url 
        
        # only update the payload with the transaction reference if it isn't already added to the payload
        if !data.key?("tx_ref")
            data.merge!({"tx_ref" => Util.transaction_reference_generator})
        end
        # check the currency to determine the type and the required parameters 
        if data["currency"] == "KES"
            required_parameters =  [ "amount", "email", "phone_number", "tx_ref", "currency"]
            type = "mpesa"
        elsif data["currency"]  == "UGX"
            required_parameters =  ["amount", "email", "phone_number", "tx_ref", "currency"]
            type = "mobile_money_uganda"
        elsif data["currency"]  == "GHS"
            required_parameters =  ["amount", "email", "phone_number", "tx_ref", "currency"]
            type = "mobile_money_ghana"
        elsif data["currency"] == "ZMW"
            required_parameters =  ["amount", "email", "phone_number","tx_ref", "currency"]
            type = "mobile_money_zambia"
        elsif data["currency"] == "RWF" 
            required_parameters =  ["amount", "email", "phone_number","tx_ref", "currency"]
            type = "mobile_money_rwanda"
        elsif data["currency"] == "XAF"  || data["currency"] == "XOF"
            required_parameters = ["amount", "email", "phone_number", "tx_ref", "currency"]
            type = "mobile_money_franco"
        else
            return "pass a valid currency"
        end

        check_passed_parameters(required_parameters, data)
        type = type
        payload = data.to_json

        response = post_request("#{base_url}#{BASE_ENDPOINTS::CHARGE_ENDPOINT}?type=#{type}", payload) 
        return response
    end

    # mthod to verify transaction
    def verify_charge(id)
        base_url = flutterwave_object.base_url

        response = get_request("#{base_url}/transactions/#{id}/verify")
        return response
end
end
