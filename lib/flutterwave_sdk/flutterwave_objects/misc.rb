require_relative "base/base.rb"
require 'json'

class Misc < Base
    def get_all_wallet_balance()
        base_url = flutterwave_object.base_url
        response = get_request("#{base_url}/balances")
        return response
    end

    def get_balance_per_currency(currency)
        base_url = flutterwave_object.base_url
        response = get_request("#{base_url}/balances/#{currency}")
        return response
    end

    def resolve_account(data)
        base_url = flutterwave_object.base_url
        required_parameters = ["account_bank", "account_number"]
        check_passed_parameters(required_parameters, data)
        payload = data.to_json
        response = post_request("#{base_url}/accounts/resolve", payload)
        return response
    end

    def resolve_bvn(bvn)
        base_url = flutterwave_object.base_url
        response = get_request("#{base_url}/kyc/bvns/#{bvn}")
        return response
    end

    def resolve_card_bin(bin)
        base_url = flutterwave_object.base_url
        response = get_request("#{base_url}/card-bins/#{bin}")
        return response
    end
end