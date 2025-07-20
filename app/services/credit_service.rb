class CreditService
  class InsufficientCreditsError < StandardError; end

  def self.deduct_credit(user, ruleset, amount = 1)
    return true if user.admin? # Admins have unlimited credits
    
    if user.sufficient_credits?(amount)
      user.deduct_credits!(amount, ruleset)
      true
    else
      raise InsufficientCreditsError, "User has insufficient credits"
    end
  end

  def self.grant_credits(user, amount, admin_user)
    raise ArgumentError, "Only admins can grant credits" unless admin_user.admin?
    raise ArgumentError, "Amount must be positive" unless amount > 0
    
    user.add_credits!(amount, admin_user)
  end

  def self.sufficient_credits?(user, required = 1)
    user.sufficient_credits?(required)
  end

  def self.credit_check_response(user)
    if user.sufficient_credits?
      { sufficient: true, credits: user.credits }
    else
      { 
        sufficient: false, 
        credits: user.credits,
        message: "You have #{user.credits} credits remaining. You need at least 1 credit to generate a ruleset."
      }
    end
  end

  def self.user_credit_summary(user)
    summary = user.credit_usage_summary
    {
      current_balance: user.credits,
      total_used: summary[:total_used],
      total_granted: summary[:total_granted],
      recent_transactions: summary[:recent_transactions].map do |transaction|
        {
          id: transaction.id,
          amount: transaction.formatted_amount,
          type: transaction.transaction_type,
          description: transaction.description,
          date: transaction.created_at.strftime("%B %d, %Y at %I:%M %p")
        }
      end
    }
  end

  def self.admin_user_overview
    users = User.includes(:credit_transactions).all
    users.map do |user|
      summary = user.credit_usage_summary
      {
        id: user.id,
        email: user.email,
        admin: user.admin?,
        current_credits: user.credits,
        total_used: summary[:total_used],
        total_granted: summary[:total_granted],
        last_activity: user.credit_transactions.recent.first&.created_at,
        rulesets_count: user.rulesets.count
      }
    end
  end
end
