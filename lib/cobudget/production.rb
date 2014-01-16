require 'playhouse/production'

module Cobudget
  class Production < Playhouse::Production
    def initialize #options
      @plays = [Cobudget::CobudgetPlay.new]
    end

    attr_reader :plays

    def routes=(routes)
      #temp fix
    end
  end
end
