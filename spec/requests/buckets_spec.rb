require 'rails_helper'

xdescribe "Buckets" do

  describe "GET '/buckets?group_id='" do
  end

  describe "PATCH '/buckets/:id'" do
  end

  describe "POST '/buckets/:id/open_for_funding'" do
    it "updates the status of the bucket to 'live'" do
    end

    it "sets the live_at attr of bucket to the current time" do
    end

    it "sends 'notify_member_with_balance_that_project_is_live' emails only to members of the group with funds" do
    end

    it "sends 'notify_member_with_zero_balance_that_project_is_live' emails only to members of the group without funds" do
    end
  end
end