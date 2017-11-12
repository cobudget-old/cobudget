class Membership < ActiveRecord::Base
  after_create :add_accounts_after_create
  belongs_to :group
  belongs_to :member, class_name: "User"

  validates :group_id, presence: true
  validates :member_id, presence: true, uniqueness: { scope: :group_id }

  scope :with_totals, -> {
    joins('LEFT JOIN (SELECT user_id, group_id, sum(amount) AS total_allocations
           FROM allocations
           GROUP BY user_id, group_id) AS alloc
           ON memberships.member_id = alloc.user_id AND memberships.group_id = alloc.group_id
           LEFT JOIN (SELECT contributions.user_id, group_id, sum(amount) AS total_contributions
           FROM contributions, buckets
           WHERE contributions.bucket_id = buckets.id
           GROUP BY contributions.user_id, buckets.group_id) as contrib
           ON memberships.member_id = contrib.user_id AND memberships.group_id = contrib.group_id')
    .select('memberships.*, COALESCE(alloc.total_allocations,0) AS total_allocations_db, 
            COALESCE(contrib.total_contributions,0) AS total_contributions_db')
  }

  scope :archived, -> { where.not(archived_at: nil) }
  scope :active, -> { where(archived_at: nil) }

  after_create :update_member_if_this_is_their_first_membership

  def total_allocations
    has_attribute?(:total_allocations_db) ? total_allocations_db : Allocation.where(user_id: member_id, group_id: group_id).sum(:amount)
  end

  def total_contributions
    has_attribute?(:total_contributions_db) ? total_contributions_db : get_total_contributions
  end

  def get_total_contributions
    group_bucket_ids = group.bucket_ids
    Contribution.where(bucket_id: group_bucket_ids, user_id: member_id).sum(:amount)
  end

  def raw_balance
    total_allocations - total_contributions
  end

  def balance
    raw_balance.floor
  end

  def formatted_balance
    Money.new(balance * 100, currency_code).format
  end

  def archived?
    archived_at
  end

  def active?
    !archived?
  end

  def archive!
    update(archived_at: DateTime.now.utc)
  end

  def reactivate!
    update(archived_at: nil)
  end

  def balance_on_status_account
    AccountService.balance(status_account_id)
  end

  def balance_on_incoming_account
    AccountService.balance(incoming_account_id)
  end

  def transactions_data_ok?
    (balance_on_status_account == raw_balance) && (balance_on_incoming_account + total_allocations == 0)
  end

  private
    def currency_code
      group.currency_code
    end

    def update_member_if_this_is_their_first_membership
      unless member.has_ever_joined_a_group?
        member.update(joined_first_group_at: Time.now.utc)
      end
    end

    def add_accounts_after_create
      status_account = Account.new({group_id: group_id})
      in_account = Account.new({group_id: group_id})
      out_account = Account.new({group_id: group_id})
      if status_account.save && in_account.save && out_account.save
        self.status_account_id = status_account.id
        self.incoming_account_id = in_account.id
        self.outgoing_account_id = out_account.id
        save!
      end
    end
end
