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

    it "sends 'notify_member_that_project_is_live' emails to all members of the group with funds" do
    end

    it "does not send 'notify_member_that_project_is_live' emails to members with zero balance" do
    end
  end
end