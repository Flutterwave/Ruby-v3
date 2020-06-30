require_relative "base.rb"

class CardBase < Base

    # method to the passed suggested auth to the corresponding value in the available hash
  def get_auth_type(suggested_auth)
    auth_map = {"pin" => :pin, "avs_vbvsecurecode" => :address, "noauth_international" => :address, "avs_noauth" => :address}

    # Raise Error if the right authorization type is not passed
    unless !auth_map.has_key? auth_map[suggested_auth]
      raise RequiredAuthError, "Required suggested authorization type not available."
    end
    return auth_map[suggested_auth]
  end


  # method to update payload
  def update_payload(suggested_auth, payload, **keyword_args)
    auth_type = get_auth_type(suggested_auth)
    
    # Error is raised if the expected suggested auth is not found in the keyword arguments
    if !keyword_args.key?(auth_type)
      raise SuggestedAuthError, "Please pass the suggested auth."
    end

    # if the authorization type is equal to address symbol, update with the required parameters
    if auth_type == :address
      required_parameters = ["city", "address", "state", "country", "zipcode"]
      check_passed_parameters(required_parameters, keyword_args[auth_type])
      authorization = {}
      authorization.merge!({"mode" => suggested_auth})
      # puts authorization
      authorization.merge!(keyword_args[auth_type])
      payload["authorization"]= authorization
      return payload
    end


    # return this updated payload if the passed authorization type isn't address symbol
    authorization = {}
    #  authorization.merge!({"mode" => suggested_auth, "fields" => keyword_args[auth_type]})
    authorization.merge!({"mode" => suggested_auth})
     puts authorization
     authorization.merge!(keyword_args[auth_type])
     payload["authorization"]= authorization
    return payload

  end
end 