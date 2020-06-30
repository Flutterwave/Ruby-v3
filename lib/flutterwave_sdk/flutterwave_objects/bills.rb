require_relative "base/base.rb"
require 'json'

class Bills < Base

    def create_bill_payment(data)
        base_url = flutterwave_object.base_url 
        required_parameters = ["country", "customer", "amount", "recurrence", "type"]
        check_passed_parameters(required_parameters, data)
        payload = data.to_json
        response = post_request("#{base_url}/bills", payload) 
        return response
    end

    def create_bulk_bill_payments(data)
        base_url = flutterwave_object.base_url 
        required_parameters = ["bulk_reference", "callback_url", "bulk_data"]
        check_passed_parameters(required_parameters, data)
        payload = data.to_json
        response = post_request("#{base_url}/bulk-bills", payload) 
        return response
    end

    def get_status_of_a_bill_payment(reference)
        base_url = flutterwave_object.base_url 
        response = get_request("#{base_url}/bills/#{reference}") 
        return response
    end

    def update_bills_order(reference, data)
        base_url = flutterwave_object.base_url 
        required_parameters = ["bulk_reference", "callback_url", "bulk_data"]
        check_passed_parameters(required_parameters, data)
        payload = data.to_json
        response = post_request("#{base_url}/product-orders/#{reference}", payload) 
        return response
    end

    def validate_bill_service(item_code, data)
        base_url = flutterwave_object.base_url 
        required_parameters = ["code", "customer"]
        check_passed_parameters(required_parameters, data)
        payload = data.to_json
        response = post_request("#{base_url}/bill-items/#{item_code}/validate", payload) 
        return response
    end

    def get_bill_categories
        base_url = flutterwave_object.base_url 
        response = get_request("#{base_url}/bill-categories")
        return response
    end

    def get_bill_payment_agencies
        base_url = flutterwave_object.base_url 
        response = get_request("#{base_url}/billers")
        return response
    end

    def get_amount_for_a_product(id, product_id)
        base_url = flutterwave_object.base_url 
        response = get_request("#{base_url}/billers/#{id}/products/#{product_id}")
        return response
    end

    def get_bill_payments(data)
        base_url = flutterwave_object.base_url
        payload = data.to_json
        response = get_request("#{base_url}/bills", payload)
        return response
    end

    def get_products_under_an_agency(id)
        base_url = flutterwave_object.base_url
        response = get_request("#{base_url}/billers/#{id}/products")
        return response
    end

    def create_order_using_billing_code_and_productid(id, product_id, data)
        base_url = flutterwave_object.base_url 
        payload = data.to_json
        response = post_request("#{base_url}/biller/#{id}/products/#{product_id}/orders", payload) 
        return response
    end
    
end