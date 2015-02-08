require 'policy_helper'

describe BucketPolicy do
  subject { policy }

  let(:policy) { BucketPolicy.new(user, bucket) }
  let(:bucket) { FactoryGirl.create(:bucket, round: round, user: user) }
  let(:another_user) { FactoryGirl.create(:user) }
  let(:another_users_bucket) { FactoryGirl.create(:bucket, round: round,
    user: another_user) }

  context 'round pending' do
    context "admin" do
      before { make_user_group_admin }

      context 'their own bucket' do
        it { should permit(:create) }
      end

      context "another user's buckets" do
        let(:bucket) { another_users_bucket }
        it { should permit(:create) }
      end
    end

    context "member" do
      before { make_user_group_member }

      context 'their own bucket' do
        it { should_not permit(:create) }
      end
    end
  end

  context 'round open to proposals' do
    let(:round) { FactoryGirl.create(:round_open_for_proposals, group: group) }

    context "admin" do
      before { make_user_group_admin }

      context 'their own bucket' do
        it { should permit(:create) }
      end

      context "another user's buckets" do
        let(:bucket) { another_users_bucket }
        it { should permit(:create) }
      end
    end

    context "member" do
      before { make_user_group_member }

      context 'their own bucket' do
        it { should permit(:create) }
      end

      context "another user's buckets" do
        let(:bucket) { another_users_bucket }
        it { should_not permit(:create) }
      end
    end

    context 'non-member' do
      it { should_not permit(:create) }
    end
  end

  context 'round open to contributions' do
    let(:round) { FactoryGirl.create(:round_open_for_contributions, group: group) }

    context "admin" do
      before { make_user_group_admin }

      context 'their own bucket' do
        it { should permit(:create) }
      end

      context "another user's buckets" do
        let(:bucket) { another_users_bucket }
        it { should permit(:create) }
      end
    end

    context "member" do
      before { make_user_group_member }

      context 'their own bucket' do
        it { should_not permit(:create) }
      end

      context "another user's buckets" do
        let(:bucket) { another_users_bucket }
        it { should_not permit(:create) }
      end
    end
  end

  context 'round closed' do
    let(:round) { FactoryGirl.create(:round_closed, group: group) }

    context "admin" do
      before { make_user_group_admin }

      context 'their own bucket' do
        it { should_not permit(:create) }
      end
    end
  end
end
