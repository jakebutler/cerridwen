class Api::V1::DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: {
      status: 'success',
      data: {
        user: user_summary,
        credits: credit_summary,
        recent_rulesets: recent_rulesets_data,
        quick_stats: quick_stats
      }
    }
  end

  def credit_status
    render json: CreditService.credit_check_response(current_user)
  end

  private

  def user_summary
    {
      id: current_user.id,
      email: current_user.email,
      admin: current_user.admin?,
      created_at: current_user.created_at,
      member_since: current_user.created_at.strftime("%B %Y")
    }
  end

  def credit_summary
    CreditService.user_credit_summary(current_user)
  end

  def recent_rulesets_data
    current_user.recent_rulesets(5).map do |ruleset|
      {
        id: ruleset.id,
        title: ruleset.title,
        uuid: ruleset.uuid,
        word_count: ruleset.word_count,
        tech_stack_count: ruleset.tech_stack_count,
        tags: ruleset.tag_array,
        created_at: ruleset.created_at,
        version: ruleset.version,
        latest_version: ruleset.latest_version?,
        project: ruleset.project ? {
          id: ruleset.project.id,
          name: ruleset.project.name
        } : nil
      }
    end
  end

  def quick_stats
    {
      total_rulesets: current_user.rulesets.count,
      total_projects: current_user.projects.count,
      credits_used_total: current_user.credit_transactions.usage.sum(:amount).abs,
      last_generation: current_user.rulesets.order(:created_at).last&.created_at
    }
  end
end
