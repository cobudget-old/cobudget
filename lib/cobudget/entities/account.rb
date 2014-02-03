require 'active_record'

module Cobudget
  class Account < ActiveRecord::Base
    belongs_to :user
    belongs_to :budget
    has_many :entries, as: :account

    def allocation_rights_cents
      EntryCollection.cast_actor(self).balance
    end
  end

end
