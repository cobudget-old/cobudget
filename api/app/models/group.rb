class Group < ActiveRecord::Base
  after_create :add_account_after_create

  has_many :buckets, dependent: :destroy
  has_many :allocations, dependent: :destroy
  has_many :memberships
  has_many :members, through: :memberships, source: :member

  validates_presence_of :name

  before_save :update_currency_symbol_if_currency_code_changed

  def add_admin(user)
    if members.include?(user)
      memberships.find_by(member: user).update(is_admin: true)
    else
      memberships.create(member: user, is_admin: true)
    end
  end

  def add_customer(email)
    customer = Stripe::Customer.create(
      :description => "Customer for Group " + self.id.to_s,
      :email => email,
      :plan => 1
    )
    self.customer_id = customer.id
    self.trial_end = Time.at(customer.subscriptions.data[0].trial_end)
    self.plan = "paid"
    self.save
  end

  def add_card(email, token)
    customer = Stripe::Customer.retrieve(self.customer_id)
    customer.source = token
    customer.email = email
    customer.save
  end

  def extend_trial
    # the number of seconds in thirty days
    thirty_days =  60 * 24 * 30

    customer = Stripe::Customer.retrieve(self.customer_id)
    sub = Stripe::Subscription.retrieve(customer.subscriptions.data[0].id)
    sub.trial_end = sub.trial_end + thirty_days
    sub.save
    self.trial_end = Time.at(sub.trial_end)
    self.save
  end

  def find_archived_members_with_funds()
    l = []
    Membership.where(group_id: id).where.not(archived_at: nil).find_each do |membership|
      if membership.raw_balance != 0
        l.push({
          membership_id: membership.id, 
          user_name: User.find(membership.member_id).name,
          archived_at: membership.archived_at,
          balance: membership.raw_balance  
          })
      end
    end
    l
  end

  def transfer_balance_from_member_to_group_account(membership_id, current_user)
    m = Membership.find(membership_id)
    amount = m.raw_balance
    ActiveRecord::Base.transaction do
      a = Allocation.create(user_id: m.member_id, group_id: id, amount: -amount)
      Transaction.create!({
        datetime: a.created_at,
        from_account_id: m.status_account_id,
        to_account_id: status_account_id,
        user_id: current_user.id,
        amount: amount
      })
    end
  end

  def transfer_memberships_to_group_account(transfer_from_list, current_user)
    transfer_from_list.each do |e|
      transfer_balance_from_member_to_group_account(e[:membership_id], current_user)
    end

    mail_admins_about_members(transfer_from_list)
  end

  def for_each_admin
    Membership.where(group_id: id, is_admin: :true, archived_at: nil).find_each do |admin|
      yield admin
    end
  end

  def mail_admins_about_members(memberlist)
    if memberlist.length > 0
      l = memberlist.map { |e| 
        e[:archived_at] = e[:archived_at].strftime("%B %d, %Y") 
        e[:balance] = Money.new(e[:balance] * 100, currency_code).format
      }
      for_each_admin do |admin|
        UserMailer.notify_admins_archived_member_funds(admin: admin.member.name_and_email, 
          group: self, memberlist: memberlist).deliver_later
      end
      if Rails.configuration.respond_to?('devops_user')
        UserMailer.notify_admins_archived_member_funds(admin: Rails.configuration.devops_user, 
          group: self, memberlist: memberlist).deliver_later
      end        
    end
  end

  def cleanup_archived_members_with_funds(current_user)
    l = find_archived_members_with_funds()
    if l.length > 0
      transfer_memberships_to_group_account(l, current_user)
    end
  end

  def add_member(user)
    memberships.create!(member: user, is_admin: false)
  end

  def total_allocations
    # total allocations to this group over all time
    allocations.sum(:amount)
  end

  def total_contributions
    Contribution.where(bucket_id: buckets.map(&:id)).sum(:amount)
  end

  def total_in_unfunded
      # amount of money in unfunded buckets
      buckets.with_totals.where("status = 'live' AND buckets.archived_at IS NULL").sum("contrib.total")
  end

  def ready_to_pay_total
      buckets.with_totals.where("status = 'funded' AND paid_at IS NULL").sum("contrib.total")
  end

  def total_paid
      # buckets.with_totals.map {|b| b.paid_at ? b.total_contributions : 0 }.sum
      buckets.with_totals.where("paid_at IS NOT NULL").sum("contrib.total")
  end

  def total_in_circulation
      # amount of money unspent, in partially funded buckets, and in funded but
      # unpaid buckets.
      total_allocations - total_paid
  end

  def balance
    # remaining to be spent
    (total_allocations - total_contributions) || 0
  end

  def group_account_balance
    Account.find(status_account_id).balance
  end

  def formatted_balance
    Money.new(balance * 100, currency_code).format
  end

  def is_launched
    members.any? && allocations.any?
  end

  def last_activity_at
    last_bucket = buckets.order(updated_at: :desc).limit(1).first
    last_bucket_updated_at = last_bucket ? last_bucket.updated_at : nil
    last_membership = memberships.order(updated_at: :desc).limit(1).first
    last_membership_updated_at = last_membership ? last_membership.updated_at : nil
    last_allocation = allocations.order(created_at: :desc).limit(1).first
    last_allocation_created_at = last_allocation ? last_allocation.created_at : nil
    last_contribution = Contribution.joins(:bucket).where(buckets: {id: buckets.pluck(:id)}).order(created_at: :desc).limit(1).first
    last_contribution_created_at = last_contribution ? last_contribution.created_at : nil
    last_comment = Comment.joins(:bucket).where(buckets: {id: buckets.pluck(:id)}).order(created_at: :desc).limit(1).first
    last_comment_updated_at = last_comment ? last_comment.created_at : nil
    [updated_at, last_bucket_updated_at, last_membership_updated_at, last_allocation_created_at, last_contribution_created_at, last_comment_updated_at].compact.max
  end

  private
    def update_currency_symbol_if_currency_code_changed
      if self.currency_code
        self.currency_symbol = Money.new(0, self.currency_code).symbol
      end
    end

    def add_account_after_create
      account = Account.create!({group_id: id})
      update!(status_account_id: account.id)
    end
end
