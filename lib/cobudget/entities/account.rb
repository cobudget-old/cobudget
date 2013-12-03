require 'active_record'

module Cobudget
  class Account < ActiveRecord::Base
    belongs_to :user
    belongs_to :budget
  end

end
