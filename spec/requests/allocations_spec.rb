require 'rails_helper'

describe "Allocations" do
  xdescribe "POST '/allocations/upload?group_id=" do
    it "uses the email addresses / amounts in the csv to generates allocations for users within specified group" do
    end

    context "email address matches existing cobudget user" do
      context "user is member of specified group" do
        it "generates an allocation for the member" do
        end

        it "sends them a 'notify_member_that_they_received_allocation' email" do
        end
      end

      context "user is not yet a member of specified group" do
        it "creates a membership between the new user and the specified group" do
        end

        it "generates an allocation for the new member" do
        end

        it "sends them an 'invite_to_group' email with a link to the group" do
        end
      end
    end

    context "email address does not match existing cobudget user" do
      it "creates a new user with that email address + a temporary name, password, and confirmation_token" do
      end

      it "creates a membership between the new user and the specified group" do
      end

      it "generates an allocation for the new member" do
      end

      it "sends an 'invite_email' to the member with a link to an account confirmation page" do
      end
    end

    context "allocation amount associated with an email address is zero" do
      it "does not generate an allocation for user with that email address" do
      end
    end
  end
end
