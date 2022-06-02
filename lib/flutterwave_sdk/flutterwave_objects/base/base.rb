require 'httparty'
require_relative "../../flutterwave_modules/base_endpoints"
require "json"
require_relative "../../error"

class Base

  attr_reader :flutterwave_object

  # method to initialize this class
  
  def initialize(flutterwave_object=nil)
    unless !flutterwave_object.nil?
      raise ArgumentError, "Flutterwave Object is required!!!"
    end
    @flutterwave_object = flutterwave_object
  end


  # method to make a get request
  def get_request(endpoint)
    # headers = {
    #     "Authorization" => "Bearer #{flutterwave_object.secret_key}"
    # }
    begin
      response = HTTParty.get(endpoint, :headers => { "Authorization" => "Bearer #{flutterwave_object.secret_key}" })
      unless (response.code == 200 || response.code == 201)
        raise FlutterwaveServerError.new(response), "HTTP Code #{response.code}: #{response.body}"
      end

      return response

      unless(response.code != 0 )
        raise FlutterwaveServerError.new(response), "Server Message: #{response.message}"
      end

      rescue JSON::ParserError => jsonerr
        raise FlutterwaveServerError.new(response) , "Invalid result data. Could not parse JSON response body \n #{jsonerr.message}"
        return response
      end
  end

  # method to make a post request
  def post_request(endpoint, data)
    begin
      response = HTTParty.post(endpoint, {
        body: data,
        headers: {
          "Content-Type" => "application/json",
          "Authorization" =>  "Bearer #{flutterwave_object.secret_key}"
        }
      })

      unless (response.code == 200 || response.code == 201)
        raise FlutterwaveServerError.new(response), "HTTP Code #{response.code}: #{response.body}"
      end
      return response
    end

  end
  # method to make a put request
  def put_request(endpoint, data)
    begin
      response = HTTParty.put(endpoint, {
        body: data,
        headers: {
          "Content-Type" => "application/json",
          "Authorization" =>  "Bearer #{flutterwave_object.secret_key}"
        }
      })

      unless (response.code == 200 || response.code == 201)
        raise FlutterwaveServerError.new(response), "HTTP Code #{response.code}: #{response.body}"
      end
      return response
  end
end

  # method to make a delete request
  def delete_request(endpoint, data)
    begin
      response = HTTParty.delete(endpoint, {
        body: data,
        headers: {
          "Content-Type" => "application/json",
          "Authorization" =>  "Bearer #{flutterwave_object.secret_key}"
        }
      })

      unless (response.code == 200 || response.code == 201)
        raise FlutterwaveServerError.new(response), "HTTP Code #{response.code}: #{response.body}"
      end
      return response
  end
end

  # method to check if the passed parameters is equal to the expected parameters
  def check_passed_parameters(required_params, passed_params)

    # This is used to check if the passed authorization parameters matches the required parameters
    required_params.each do |k, v|
      if !passed_params.key?(k)
        raise IncompleteParameterError, "Parameters Incomplete, Missing Parameter: #{k}, Please pass in the complete parameter."
      end
    end
  end

end
