require 'active_record'

module Cobudget
  class Account < ActiveRecord::Base
    belongs_to :user
    belongs_to :budget
    has_many :entries, as: :account

    def allocation_rights_cents
      EntryCollection.cast_actor(self).balance
    end

    def user_email
      if user
        user.email
      else
        "N/A"
      end
    end

    def as_json(options={})
      super(
        methods: [:allocation_rights_cents, :user_email]
      )
    end
  end
end
