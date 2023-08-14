require_relative "base/base.rb"
require 'json'

class FawryPayment < Base
    def initiate_charge(data)
        base_url = flutterwave_object.base_url

        # only update the payload with the transaction reference if it isn't already added to the payload
        if !data.key?("tx_ref")
            data.merge!({"tx_ref" => Util.transaction_reference_generator})
        end
            required_parameters =  [ "amount", "email", "tx_ref", "currency"]

        check_passed_parameters(required_parameters, data)
        type = "fawry_pay"
        payload = data.to_json

        response = post_request("#{base_url}#{BASE_ENDPOINTS::CHARGE_ENDPOINT}?type=#{type}", payload)
        return response
    end

    def verify_charge(id)
        base_url = flutterwave_object.base_url

        response = get_request("#{base_url}/transactions/#{id}/verify")
        return response
    end
end
