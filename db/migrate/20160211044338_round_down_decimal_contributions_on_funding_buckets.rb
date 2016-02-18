class RoundDownDecimalContributionsOnFundingBuckets < ActiveRecord::Migration
  def up
    # for all currently funding buckets
    Bucket.where(status: "live").each do |bucket|
      group = bucket.group

      bucket.contributions.each do |contribution|
        user = contribution.user
        amount = contribution.amount
        rounded_down_amount = amount.to_i
        difference = amount - rounded_down_amount

        # if contribution amount is non-integer
        if difference > 0
          if rounded_down_amount > 0
            # if rounded_down_amount is greater than zero, round down contribution's amount
            contribution.update(amount: rounded_down_amount)
          else
            # if rounded_down_amount is zero, destroy contribution
            contribution.destroy
          end
          
          # give difference back to user
          Allocation.create(group: group, user: user, amount: difference)
        end
      end
    end
  end
end
