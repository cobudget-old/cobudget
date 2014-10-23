# This controller is not directly assocated with any model in the DB.
# Instead it gives an overview of information about a contributor for
# a given round. (Allocation amount, amount contributed so far, etc.)
#
class ContributorsController < ApplicationController
  skip_before_filter :authenticate_from_token!

  api :GET, 'rounds/:round_id/contributors/:user_id',
            'Get a contributor\'s details for a given round'
  def show
    round
    allocation = Allocation.where(round_id: params[:round_id],
                                  user_id: params[:id]).first
    alloc_amt = allocation ? allocation.amount_cents : 0

    contributions = Contribution.for_round(params[:round_id])
                                .where(user_id: params[:id])

    render json: { contributor: {
      allocation_amount_cents: alloc_amt,
      contributions: contributions } }
  end

  private
    def round
      @round ||= Round.includes(:allocations).find(params[:round_id])
    end
end
