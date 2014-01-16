require 'pusher'

module Cobudget
  class CobudgetTheatre < Playhouse::Theatre
    ROOT_PATH = File.expand_path(File.join(File.dirname(__FILE__), '..'))

    Pusher.key = '6ea7addcc0137ddf6cf0'
    Pusher.secret = '882cd62d5475bc7edee3'
    Pusher.app_id = '59272'

    Money.default_currency = Money::Currency.new('NZD')

    def push_to_pusher(event_name, field_name, data)
      to_push = Hash.new
      to_push[field_name.to_sym] = data
      Pusher.trigger('cobudget', event_name, to_push)

      #Theatre.push_to_pusher('bucket_created', 'bucket', data) would be the call from a context

      #old syntax that used to be in contexts - provided for reference
      #Pusher.trigger('cobudget', 'bucket_created', {bucket: data})
    end
  end
end