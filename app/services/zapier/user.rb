module Zapier
  class User < Zapier::Base
    def call_operation
      HTTParty.post('https://hooks.zapier.com/hooks/catch/2984499/z0q3t0/', body: params)
    end

    def params
      {
        user_name: resource.name,
        user_email: resource.email
      }
    end
  end
end
