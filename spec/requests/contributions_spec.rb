require 'rails_helper'

xdescribe "Contributions" do
  # let(:contribution_user) { user }

  describe "GET '/contributions?bucket_id='" do

    it "returns all contributions for specified bucket" do
    end
  end

  describe "POST /contributions" do
    # let(:contribution_params) { {
    #   contribution: {
    #     bucket_id: bucket.id,
    #     user_id: contribution_user.id,
    #     amount: "25"
    #   }
    # }.to_json }

    it "creates a new contribution" do
    end

    it "returns that contribution as json" do
    end

    it "sends a 'notify_author_that_bucket_received_funding' email to the author of the bucket" do
    end

    context "the bucket becomes fully funded" do
      it "sends a 'notify_author_that_bucket_received_contribution' email to the author of the bucket" do
      end

      it "sends 'notify_author_that_bucket_is_funded' email to the author of the bucket" do
      end

      it "sends 'notify_funder_that_bucket_is_funded' emails to all unique funders of the bucket" do
      end

      it "does not send 'notify_funder_that_bucket_is_funded' to the author of the bucket" do
      end
    end

    context "the funder is also the author of the bucket" do
      it "does not send the author an email" do
      end
    end
  end
end