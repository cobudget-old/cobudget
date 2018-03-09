module Zapier
  class Base
    include HTTParty

    attr_accessor :error_message, :response, :code, :body
    attr_reader :resource

    def initialize(resource)
      @resource = resource
    end

    def post_to_zapier
      self.response = call_operation
      self.body = response.parsed_response
      self.code = response.code
      self.error_message = response.body
      success?
    end

    def success_status_codes
      [200]
    end

    def success?
      return true if success_status_codes.include?(code)
      Rails.logger.error(error_message)
      false
    end
  end
end
