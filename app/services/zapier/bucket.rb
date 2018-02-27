module Zapier
  class Bucket < Zapier::Base
    def call_operation
      HTTParty.post(ENV["ZAPIER_NEW_BUCKET"], body: params)
    end

    def params
      {
        bucket_name: resource.name,
        bucket_owner: resource.user.email,
        bucket_description: resource.description
      }
    end
  end
end
