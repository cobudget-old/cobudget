require 'active_record'
require 'ancestry'
require 'cobudget/entities/user'
require 'cobudget/entities/bucket'

module Cobudget
  class Comment < ActiveRecord::Base
    has_ancestry

    belongs_to :user
    belongs_to :bucket

    def as_json(options={})
      super(
        methods: :children,
        include: {
          user: {
            methods: :name_or_email
          }
        }
      )
    end
  end
end
