require 'rails_helper'

xdescribe "Contributions" do
  # let(:contribution_user) { user }

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

    it "sends a 'notify_author_that_project_received_funding' email to the author of the project" do
    end

    context "the project becomes fully funded" do
      it "sends 'notify_author_that_project_target_met' email to the author of the project" do
      end

      it "does not send a 'notify_author_that_project_received_funding' email to the author of the project" do
      end
    end

    context "the funder is also the author of the project" do
      it "does not send the author an email" do
      end
    end
  end
end