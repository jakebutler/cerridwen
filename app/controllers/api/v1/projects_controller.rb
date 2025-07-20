class Api::V1::ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:show, :update, :destroy, :generate_ruleset]
  before_action :check_project_ownership, only: [:show, :update, :destroy, :generate_ruleset]
  before_action :check_credits, only: [:generate_ruleset]

  def index
    @projects = current_user.projects.recent
    render json: @projects.map { |project| project_json(project) }
  end

  def show
    render json: project_json(@project)
  end

  def create
    @project = current_user.projects.build(project_params)
    
    if @project.save
      render json: project_json(@project), status: :created
    else
      render json: { errors: @project.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @project.update(project_params)
      render json: project_json(@project)
    else
      render json: { errors: @project.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    head :no_content
  end

  def generate_ruleset
    begin
      # Use Active Agent service for real LLM integration
      service = ActiveAgentRulesService.new(@project, current_user)
      
      if service.generate_ruleset
        latest_ruleset = current_user.rulesets.where(project: @project).order(:version).last
        
        # Deduct credit after successful generation
        CreditService.deduct_credit(current_user, latest_ruleset)
        
        render json: {
          status: 'success',
          message: '🎉 AI-powered ruleset generated with OpenAI and community insights!',
          data: {
            id: @project.id,
            ruleset_id: latest_ruleset.id,
            version: latest_ruleset.version,
            content: latest_ruleset.content,
            content_preview: latest_ruleset.content[0..300] + '...',
            created_at: latest_ruleset.created_at,
            dev_identity: @project.dev_identity,
            tech_stack: @project.tech_stack,
            word_count: latest_ruleset.word_count,
            tech_stack_count: latest_ruleset.tech_stack_count,
            tags: latest_ruleset.tag_array,
            generator: 'active_agent_openai',
            model: 'gpt-4o',
            community_enhanced: true,
            credits_remaining: current_user.credits
          }
        }, status: :created
      else
        render json: {
          status: 'error',
          message: 'Failed to generate AI-powered ruleset',
          errors: service.errors
        }, status: :unprocessable_entity
      end
    rescue CreditService::InsufficientCreditsError => e
      render json: {
        status: 'error',
        message: 'Insufficient credits',
        error: e.message,
        credits_remaining: current_user.credits
      }, status: :payment_required
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def check_project_ownership
    unless @project.user == current_user
      render json: { error: 'Unauthorized access to project' }, status: :forbidden
    end
  end

  def check_credits
    unless CreditService.sufficient_credits?(current_user)
      credit_info = CreditService.credit_check_response(current_user)
      render json: {
        status: 'error',
        message: credit_info[:message],
        credits_remaining: credit_info[:credits]
      }, status: :payment_required
    end
  end

  def project_params
    params.require(:project).permit(:name, :description, :dev_identity, :requirements_file_content, tech_stack: [])
  end

  def project_json(project)
    {
      id: project.id,
      name: project.name,
      description: project.description,
      tech_stack: project.tech_stack,
      dev_identity: project.dev_identity,
      requirements_file_content: project.requirements_file_content,
      created_at: project.created_at,
      updated_at: project.updated_at,
      latest_ruleset: project.latest_ruleset ? ruleset_json(project.latest_ruleset) : nil
    }
  end

  def ruleset_json(ruleset)
    {
      id: ruleset.id,
      version: ruleset.version,
      uuid: ruleset.uuid,
      is_public: ruleset.is_public,
      created_at: ruleset.created_at
    }
  end
end
