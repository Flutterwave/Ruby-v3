require_relative "base/base.rb"
require 'json'

class Settlements < Base

    def get_settlements
        base_url = flutterwave_object.base_url 
        response = get_request("#{base_url}/settlements") 
        return response
    end

    def get_settlement(id)
        base_url = flutterwave_object.base_url 
        response = get_request("#{base_url}/settlements/#{id}") 
        return response
    end
end