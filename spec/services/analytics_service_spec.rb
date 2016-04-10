require 'rails_helper'

describe "AnalyticsService" do
  describe "#report" do
    describe "#cumulative_user_count_data" do
      it "works" do
        Timecop.freeze(3.days.ago) { create_list(:user, 2) }
        Timecop.freeze(2.days.ago) { create_list(:user, 3) }
        Timecop.freeze(1.days.ago) { create_list(:user, 5) }
        Timecop.return

        create_list(:user, 1)

        cumulative_user_count_data = AnalyticsService.report[:cumulative_user_count_data]
        expect(cumulative_user_count_data).to eq({
          3.days.ago.strftime('%Y-%m-%d') => 2,
          2.days.ago.strftime('%Y-%m-%d') => 5,
          1.days.ago.strftime('%Y-%m-%d') => 10,
          DateTime.now.utc.strftime('%Y-%m-%d') => 11
        })
      end
    end

    describe "#cumulative_group_count_data" do
      it "works" do
        Timecop.freeze(3.days.ago) { create_list(:group, 4) }
        Timecop.freeze(2.days.ago) { create_list(:group, 2) }
        Timecop.freeze(1.days.ago) { create_list(:group, 1) }
        Timecop.return

        create_list(:group, 5)

        cumulative_group_count_data = AnalyticsService.report[:cumulative_group_count_data]
        expect(cumulative_group_count_data).to eq({
          3.days.ago.strftime('%Y-%m-%d') => 4,
          2.days.ago.strftime('%Y-%m-%d') => 6,
          1.days.ago.strftime('%Y-%m-%d') => 7,
          DateTime.now.utc.strftime('%Y-%m-%d') => 12
        })
      end
    end

    describe "#contribution_count_data" do
      it "works" do
        Timecop.freeze(3.days.ago) { create_list(:contribution, 2) }
        Timecop.freeze(2.days.ago) { create_list(:contribution, 5) }
        Timecop.freeze(1.days.ago) { create_list(:contribution, 4) }
        Timecop.return

        create_list(:contribution, 1)

        contribution_count_data = AnalyticsService.report[:contribution_count_data]
        expect(contribution_count_data).to eq({
          3.days.ago.strftime('%Y-%m-%d') => 2,
          2.days.ago.strftime('%Y-%m-%d') => 5,
          1.days.ago.strftime('%Y-%m-%d') => 4,
          DateTime.now.utc.strftime('%Y-%m-%d') => 1
        })
      end
    end
  end
end
