require 'rails_helper'

describe "Allocations" do

  xdescribe "POST '/allocations/upload?group_id=" do
    it "uses the email addresses / amounts in the csv to generates allocations for users within specified group" do
    end

    context "allocation amount associated with an email address is zero" do
      it "does not generate an allocation for user with that email address" do
      end
    end

    context "csv contains email addresses of people not yet users of cobudget" do
      it "creates a new user with that email address + a temporary name" do
      end

      it "creates a membership between the new user and the specified group" do
      end

      it "generates an allocation for the new member" do
      end
    end

    context "csv contains emails addresses of users not yet a part of the group" do
      it "creates a membership between the new user and the specified group" do
      end

      it "generates an allocation for the new member" do
      end
    end
  end
end
