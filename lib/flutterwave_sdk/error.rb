class FlutterwaveServerError < StandardError
	attr_reader :response
	def initialize(response=nil)
		@response = response
	end
end

class FlutterwaveBadKeyError < StandardError
end

class IncompleteParameterError < StandardError
end

class SuggestedAuthError < StandardError
end