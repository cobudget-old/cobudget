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

    describe "#group_data" do
      it "works" do
        five_months_ago = 5.months.ago
        four_months_ago = 4.months.ago
        three_months_ago = 3.months.ago
        two_months_ago = 2.months.ago
        one_month_ago = 1.month.ago

        group_1, group_1_admin, group_2, group_2_admin, group_3, group_3_admin = nil, nil, nil, nil, nil, nil

        Timecop.freeze(five_months_ago) do
          group_1 = create(:group)
          group_1_admin = create(:user)
          group_1.add_admin(group_1_admin)
          create_list(:membership, 4, group: group_1)
        end

        Timecop.freeze(four_months_ago) do
          group_2 = create(:group)
          group_2_admin = create(:user)
          group_2.add_admin(group_2_admin)
          create_list(:membership, 2, group: group_2)
        end

        Timecop.freeze(three_months_ago) do
          group_3 = create(:group)
          group_3_admin = create(:user)
          group_3.add_admin(group_3_admin)
          create_list(:membership, 5, group: group_3)
        end

        Timecop.freeze(three_months_ago) do
          bucket = create(:bucket, group: group_1, user: group_1.members.first)
          funder = group_1.members.last
          funder.allocations.create(amount: 1, group: group_1)
          create(:contribution, bucket: bucket, user: funder)
        end

        Timecop.freeze(two_months_ago) do
          bucket = create(:bucket, group: group_3, user: group_3.members.first)
          create(:comment, bucket: bucket, user: group_3.members.last)
        end

        Timecop.freeze(one_month_ago) do
          create(:allocation, group: group_2, user: group_2.members.first)
        end

        Timecop.return

        group_data = AnalyticsService.report[:group_data]

        group_2_data = group_data[0]
        group_3_data = group_data[1]
        group_1_data = group_data[2]

        expect(group_2_data[:id]).to eq(group_2.id)
        expect(group_3_data[:id]).to eq(group_3.id)
        expect(group_1_data[:id]).to eq(group_1.id)

        expect(group_2_data).to eq({
          admins: [
            { email: group_2_admin.email, name: group_2_admin.name }
          ],
          id: group_2.id,
          created_at: group_2.created_at,
          last_activity_at: one_month_ago,
          membership_count: 3,
          name: group_2.name
        })

        expect(group_1_data).to eq({
          admins: [
            { email: group_1_admin.email, name: group_1_admin.name }
          ],
          id: group_1.id,
          created_at: group_1.created_at,
          last_activity_at: three_months_ago,
          membership_count: 5,
          name: group_1.name
        })

        expect(group_3_data).to eq({
          admins: [
            { email: group_3_admin.email, name: group_3_admin.name }
          ],
          id: group_3.id,
          created_at: group_3.created_at,
          last_activity_at: two_months_ago,
          membership_count: 6,
          name: group_3.name
        })
      end
    end
  end
end
