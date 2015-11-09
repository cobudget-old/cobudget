require 'rails_helper'

describe "DeliverDailyEmailDigest" do
  describe "#to_subscribers!" do
    before do
      # at this particular time in the world ..
      @current_utc_time = DateTime.parse("2015-11-05T05:00:00Z")

      # for the parisians (UTC offset +60 min) it is currently 6AM
      @parisian_user_1 = create(:user, utc_offset: +60)
      @parisian_user_2 = create(:user, utc_offset: +60)

      # for the oaklanders (UTC offset -480 min) it is currently 9PM
      oakland_user_1 = create(:user, utc_offset: -480)
      oakland_user_2 = create(:user, utc_offset: -480)

      # and for the aucklanders (UTC offset +720 min) it is currently 6PM
      auckland_user_1 = create(:user, utc_offset: +720)
      auckland_user_2 = create(:user, utc_offset: +720)

      # all are members of the same group
      User.all.each { |user| create(:membership, group: group, member: user) }      

      # and just an hour ago, there was some recent activity in the group!
      Timecop.freeze(@current_utc_time - 1.hour) do
        create(:draft_bucket, group: group) # a new idea was made
        create(:live_bucket, group: group) # an idea started its funding phase
        create(:funded_bucket, group: group) # and a funding bucket became fully funded
      end
    end

    after do
      ActionMailer::Base.deliveries.clear
      Timecop.return
    end

    it "sends emails to all users with recent activity whose local time is currently between 6am and 7am" do
      # but when the daily email digest is sent, only the parisians know about it, because it's 6am for them
      Timecop.freeze(@current_utc_time) do
        DeliverDailyEmailDigest.to_subscribers!
        @sent_emails = ActionMailer::Base.deliveries
        @recipient_email_addresses = @sent_emails.map { |e| e.to.first }

        expect(@recipient_email_addresses.length).to eq(2)      
        expect(@recipient_email_addresses).to include(@parisian_user_1.email)
        expect(@recipient_email_addresses).to include(@parisian_user_2.email)
      end
    end

    context "user does not have a utc_offset specified yet" do
      it "does not send any emails" do
        # but what if one of our parisian users doesn't have a utc_offset associated with their account yet?
        @parisian_user_1.update(utc_offset: nil)
        # then, our server has no idea that they're in paris, and that its 6am there.

        # so, when it's 6am in paris
        Timecop.freeze(@current_utc_time) do
          # and the digest is sent out
          DeliverDailyEmailDigest.to_subscribers!
          @sent_emails = ActionMailer::Base.deliveries
          @recipient_email_addresses = @sent_emails.map { |e| e.to.first }

          # only 1 email is sent to parisian user 2
          expect(@recipient_email_addresses.length).to eq(1)    
          expect(@recipient_email_addresses).not_to include(@parisian_user_1.email)
          expect(@recipient_email_addresses).to include(@parisian_user_2.email)
          # because the server has no idea that parisian user 1 is in paris
        end
      end
    end

    context "there has been no recent activity" do
      it "does not send any emails" do
        # and what if both parisian users have utc_offsets associated with their accounts,
        # but there has been no recent activity?
        group.buckets.destroy_all

        # then, when it's 6am in paris
        Timecop.freeze(@current_utc_time) do
          # and the digest is sent out
          DeliverDailyEmailDigest.to_subscribers!
          sent_emails = ActionMailer::Base.deliveries

          # no emails are sent, because there's nothing to report on
          expect(sent_emails.length).to eq(0)
        end
      end
    end

    context "users not subscribed to daily digest" do
      it "does not send daily digest emails" do
        User.update_all(subscribed_to_daily_digest: false)

        Timecop.freeze(@current_utc_time) do
          DeliverDailyEmailDigest.to_subscribers!
          sent_emails = ActionMailer::Base.deliveries
          expect(sent_emails.length).to eq(0)    
        end
      end
    end
  end
end