module ActionMailer
  class Base
    def do_not_deliver
      def self.deliver
        false
      end
    end
  end
end
