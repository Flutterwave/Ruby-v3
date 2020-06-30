require_relative "base/base.rb"
require 'json'

class Bank < Base

    def get_all_banks(country)
        base_url = flutterwave_object.base_url
        response = get_request("#{base_url}/banks/#{country}")
        return response
    end

    def get_bank_branch(id)
        base_url = flutterwave_object.base_url
        response = get_request("#{base_url}/banks/#{id}/branches")
        return response
    end
end