require 'rails_helper'

describe "DeliverDailyEmailDigest" do
  describe "#to_subscribers!" do
    after do
      ActionMailer::Base.deliveries.clear
      Timecop.return
    end

    it "sends emails to all users whose local time is currently between 6am and 7am" do
      current_utc_time = "2015-11-05T05:00:00Z"
      Timecop.freeze(DateTime.parse(current_utc_time))
      # in paris (UTC offset +60 min) it is currently 6AM
      # in oakland (UTC offset -480 min) it is currently 9PM
      # in auckland (UTC offset +720 min) it is currently 6PM

      parisian_user_1 = create(:user, utc_offset: +60)
      parisian_user_2 = create(:user, utc_offset: +60)

      oakland_user_1 = create(:user, utc_offset: -480)
      oakland_user_2 = create(:user, utc_offset: -480)

      auckland_user_1 = create(:user, utc_offset: +720)
      auckland_user_2 = create(:user, utc_offset: +720)

      DeliverDailyEmailDigest.to_subscribers!
      @sent_emails = ActionMailer::Base.deliveries
      @recipient_email_addresses = @sent_emails.map { |e| e.to.first }

      expect(@recipient_email_addresses.length).to eq(2)      
      expect(@recipient_email_addresses).to include(parisian_user_1.email)
      expect(@recipient_email_addresses).to include(parisian_user_2.email)
    end

    xcontext "user does not have a utc_offset specified yet" do
      it "does not send any emails" do
        
      end
    end

    xcontext "there has been no recent activity" do
      it "does not send any emails" do

      end
    end
  end
end