require 'rails_helper'

describe "UserService" do
  describe "#set_utc_offset(user:, utc_offset:)" do
    before do
      UserService.set_utc_offset(user: user, utc_offset: -480)
    end

    it "updates the user's utc_offset" do
      expect(user.utc_offset).to eq(-480)
    end

    context "user does not have email digest background job scheduled" do
      it "schedules one" do
      end
    end
  end
end
