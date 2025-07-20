class Api::V1::ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :update, :destroy, :generate_ruleset]

  def index
    @projects = Project.recent
    render json: @projects.map { |project| project_json(project) }
  end

  def show
    render json: project_json(@project)
  end

  def create
    # Use test user for Active Agent testing
    test_user = User.find_by(email: 'test@example.com')
    @project = Project.new(project_params.merge(user: test_user))
    
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
    # Use Active Agent service for real LLM integration
    service = ActiveAgentRulesService.new(@project)
    
    if service.generate_ruleset
      latest_ruleset = @project.rulesets.order(:version).last
      
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
          word_count: latest_ruleset.content.split.length,
          generator: 'active_agent_openai',
          model: 'gpt-4o',
          community_enhanced: true
        }
      }, status: :created
    else
      render json: {
        status: 'error',
        message: 'Failed to generate AI-powered ruleset',
        errors: service.errors
      }, status: :unprocessable_entity
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
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
