class Api::V1::AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin

  def users_overview
    users_data = CreditService.admin_user_overview
    render json: {
      status: 'success',
      data: {
        users: users_data,
        total_users: users_data.size,
        total_admins: users_data.count { |u| u[:admin] },
        total_credits_used: users_data.sum { |u| u[:total_used] },
        total_rulesets: users_data.sum { |u| u[:rulesets_count] }
      }
    }
  end

  def user_details
    user = User.find(params[:user_id])
    credit_summary = CreditService.user_credit_summary(user)
    
    render json: {
      status: 'success',
      data: {
        user: {
          id: user.id,
          email: user.email,
          admin: user.admin?,
          created_at: user.created_at,
          rulesets_count: user.rulesets.count
        },
        credits: credit_summary
      }
    }
  end

  def grant_credits
    user = User.find(params[:user_id])
    amount = params[:amount].to_i
    
    if amount <= 0
      render json: { error: 'Amount must be positive' }, status: :unprocessable_entity
      return
    end

    begin
      CreditService.grant_credits(user, amount, current_user)
      render json: {
        status: 'success',
        message: "Successfully granted #{amount} credits to #{user.email}",
        data: {
          user_id: user.id,
          new_balance: user.credits,
          amount_granted: amount
        }
      }
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def credit_transactions
    user = User.find(params[:user_id])
    transactions = user.credit_transactions.recent.includes(:ruleset).limit(50)
    
    render json: {
      status: 'success',
      data: transactions.map do |transaction|
        {
          id: transaction.id,
          amount: transaction.formatted_amount,
          type: transaction.transaction_type,
          description: transaction.description,
          created_at: transaction.created_at,
          ruleset: transaction.ruleset ? {
            id: transaction.ruleset.id,
            title: transaction.ruleset.title,
            uuid: transaction.ruleset.uuid
          } : nil
        }
      end
    }
  end

  def system_stats
    render json: {
      status: 'success',
      data: {
        total_users: User.count,
        total_admins: User.admins.count,
        total_projects: Project.count,
        total_rulesets: Ruleset.count,
        total_credits_distributed: CreditTransaction.grants.sum(:amount),
        total_credits_used: CreditTransaction.usage.sum(:amount).abs,
        recent_activity: {
          new_users_this_week: User.where(created_at: 1.week.ago..Time.current).count,
          rulesets_generated_this_week: Ruleset.where(created_at: 1.week.ago..Time.current).count,
          credits_used_this_week: CreditTransaction.usage.where(created_at: 1.week.ago..Time.current).sum(:amount).abs
        }
      }
    }
  end

  private

  def ensure_admin
    unless current_user.admin?
      render json: { error: 'Admin access required' }, status: :forbidden
    end
  end
end
