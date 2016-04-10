require 'rails_helper'

describe "AnalyticsService" do
  describe "#report" do
    describe "#user_count" do
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

        user_count = AnalyticsService.report[:user_count]
        expect(user_count).to eq({
          3.days.ago.strftime('%Y-%m-%d') => 2,
          2.days.ago.strftime('%Y-%m-%d') => 5,
          1.days.ago.strftime('%Y-%m-%d') => 10,
          DateTime.now.utc.strftime('%Y-%m-%d') => 11
        })
      end
    end

    describe "#group_count" do
      it "works" do
        Timecop.freeze(3.days.ago) do
          create_list(:group, 4)
        end

        Timecop.freeze(2.days.ago) do
          create_list(:group, 2)
        end

        Timecop.freeze(1.days.ago) do
          create_list(:group, 1)
        end

        Timecop.return
        create_list(:group, 5)

        group_count = AnalyticsService.report[:group_count]
        expect(group_count).to eq({
          3.days.ago.strftime('%Y-%m-%d') => 4,
          2.days.ago.strftime('%Y-%m-%d') => 6,
          1.days.ago.strftime('%Y-%m-%d') => 7,
          DateTime.now.utc.strftime('%Y-%m-%d') => 12
        })
      end
    end
  end
end
