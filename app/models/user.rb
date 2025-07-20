class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :projects, dependent: :destroy
  has_many :rulesets, dependent: :destroy
  has_many :credit_transactions, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :credits, presence: true, numericality: { greater_than_or_equal_to: 0 }

  after_create :create_initial_credits

  scope :admins, -> { where(email: admin_emails) }
  scope :regular_users, -> { where.not(email: admin_emails) }

  def admin?
    self.class.admin_emails.include?(email)
  end

  def sufficient_credits?(required = 1)
    admin? || credits >= required
  end

  def deduct_credits!(amount, ruleset = nil)
    return true if admin? # Admins have unlimited credits
    
    if credits >= amount
      update!(credits: credits - amount)
      credit_transactions.create_usage_transaction(self, ruleset, -amount)
      true
    else
      false
    end
  end

  def add_credits!(amount, admin_user)
    update!(credits: credits + amount)
    credit_transactions.create_admin_grant(self, amount, admin_user)
  end

  def credit_usage_summary
    {
      total_used: credit_transactions.usage.sum(:amount).abs,
      total_granted: credit_transactions.grants.sum(:amount),
      current_balance: credits,
      recent_transactions: credit_transactions.recent.limit(10)
    }
  end

  def recent_rulesets(limit = 5)
    rulesets.order(created_at: :desc).limit(limit)
  end

  private

  def create_initial_credits
    credit_transactions.create_initial_credits(self)
  end

  def self.admin_emails
    ENV['ADMIN_EMAILS']&.split(',')&.map(&:strip) || []
  end
end
