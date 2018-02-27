module Zapier
  class NewBucket < Zapier::Base
    def call_operation
      HTTParty.post(ENV["ZAPIER_NEW_BUCKET"], body: params)
    end

    def params
      {
        bucket_name: resource.name,
        bucket_owner: resource.user.email,
        bucket_description: resource.description,
        funding_target: resource.target,
        status: resource.status_readable,
        bucket_link: "#{Rails.application.config.action_mailer.default_url_options[:host]}/#/buckets/#{resource.id}"
      }
    end
  end
end
