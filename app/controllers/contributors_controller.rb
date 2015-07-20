# This controller is not directly assocated with any model in the DB.
# Instead it gives an overview of information about a contributor for
# a given round. (Allocation amount, amount contributed so far, etc.)
#
class ContributorsController < ApplicationController
  skip_before_filter :authenticate_from_token!

  api :GET, '/rounds/:round_id/contributors/:user_id',
            'Get a contributor\'s details for a given round'
  def show
    round
    allocation = Allocation.where(round_id: params[:round_id],
                                  user_id: params[:id]).first
    alloc_amt = allocation ? allocation.amount : BigDecimal.new(0)

    contributions = Contribution.for_round(params[:round_id])
                                .where(user_id: params[:id])

    render json: { contributor: {
      allocation_amount: alloc_amt,
      contributions: contributions } }
  end

  api :GET, '/rounds/:round_id/contributors/',
            'Gets all contributor\'s details for a given round'
  def index
    allocations = round.allocations.order(amount: :desc)
    members_without_allocations = round.group.members.order(name: :asc).where('users.id not in (?)', allocations.map{|a| a.user_id})
    contributors = []
    allocations.each do |allocation|
      contributions = Contribution.for_round(params[:round_id])
                                  .where(user_id: allocation.user_id).order(amount: :desc)
      contributors << {
        user: UserSerializer.new(allocation.user).attributes,
        allocation: AllocationSerializer.new(allocation).attributes,
        contributions: ActiveModel::ArraySerializer.new(contributions, each_serializer: ContributionShortSerializer)
      }
    end
    members_without_allocations.each do |member|
      contributors << {
        user: UserSerializer.new(member).attributes,
        allocation: nil
      }
    end
    render json: { contributors: contributors }
  end

  private 
    def round
      @round ||= Round.includes(:allocations).find(params[:round_id])
    end
end
