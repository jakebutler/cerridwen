class CreditTransaction < ApplicationRecord
  belongs_to :user
  belongs_to :ruleset, optional: true

  validates :amount, presence: true
  validates :transaction_type, presence: true, inclusion: { in: %w[usage admin_grant initial] }
  validates :description, presence: true

  scope :usage, -> { where(transaction_type: 'usage') }
  scope :grants, -> { where(transaction_type: 'admin_grant') }
  scope :initial, -> { where(transaction_type: 'initial') }
  scope :recent, -> { order(created_at: :desc) }

  def self.create_usage_transaction(user, ruleset, amount = -1)
    create!(
      user: user,
      ruleset: ruleset,
      amount: amount,
      transaction_type: 'usage',
      description: "Generated ruleset: #{ruleset.title || 'Untitled'}"
    )
  end

  def self.create_admin_grant(user, amount, admin_user)
    create!(
      user: user,
      amount: amount,
      transaction_type: 'admin_grant',
      description: "Credits granted by admin: #{admin_user.email}"
    )
  end

  def self.create_initial_credits(user, amount = 10)
    create!(
      user: user,
      amount: amount,
      transaction_type: 'initial',
      description: "Initial credits upon registration"
    )
  end

  def credit_or_debit
    amount >= 0 ? 'credit' : 'debit'
  end

  def formatted_amount
    amount >= 0 ? "+#{amount}" : amount.to_s
  end
end
