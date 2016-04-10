require 'rails_helper'

describe "AnalyticsService" do
  describe "#user_count_report" do
    it "works" do
      Timecop.freeze(3.days.ago) do
        create_list(:user, 2)
      end

      Timecop.freeze(2.days.ago) do
        create_list(:user, 3)
      end

      Timecop.freeze(1.days.ago) do
        create_list(:user, 5)
      end

      Timecop.return
      create_list(:user, 1)

      expect(AnalyticsService.user_count_report).to eq({
        3.days.ago.strftime('%Y-%m-%d') => 2,
        2.days.ago.strftime('%Y-%m-%d') => 5,
        1.days.ago.strftime('%Y-%m-%d') => 10,
        DateTime.now.utc.strftime('%Y-%m-%d') => 11
      })
    end
  end
end
