class Api::V1::RulesetsController < ApplicationController
  before_action :set_project, except: [:show_public]
  before_action :set_ruleset, only: [:show, :update, :destroy]

  def index
    @rulesets = @project.rulesets.by_version
    render json: @rulesets.map { |ruleset| ruleset_json(ruleset) }
  end

  def show
    render json: ruleset_json(@ruleset, include_content: true)
  end

  def show_public
    @ruleset = Ruleset.find_by!(uuid: params[:uuid])
    if @ruleset.is_public?
      render json: ruleset_json(@ruleset, include_content: true, public_view: true)
    else
      render json: { error: 'Ruleset not found or not public' }, status: :not_found
    end
  end

  def create
    @ruleset = @project.rulesets.build(ruleset_params)
    
    if @ruleset.save
      render json: ruleset_json(@ruleset, include_content: true), status: :created
    else
      render json: { errors: @ruleset.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @ruleset.update(ruleset_params)
      render json: ruleset_json(@ruleset, include_content: true)
    else
      render json: { errors: @ruleset.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @ruleset.destroy
    head :no_content
  end

  private

  def set_project
    @project = current_user.projects.find(params[:project_id])
  end

  def set_ruleset
    @ruleset = @project.rulesets.find(params[:id])
  end

  def ruleset_params
    params.require(:ruleset).permit(:content, :is_public)
  end

  def ruleset_json(ruleset, include_content: false, public_view: false)
    json = {
      id: ruleset.id,
      version: ruleset.version,
      uuid: ruleset.uuid,
      is_public: ruleset.is_public,
      created_at: ruleset.created_at,
      updated_at: ruleset.updated_at
    }

    if include_content
      json[:content] = ruleset.content
    end

    unless public_view
      json[:project] = {
        id: ruleset.project.id,
        name: ruleset.project.name
      }
    end

    json
  end
end
