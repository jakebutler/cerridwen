class Api::V1::RulesetsController < ApplicationController
  before_action :authenticate_user!, except: [:show_public]
  before_action :set_project, except: [:show_public, :user_index]
  before_action :set_ruleset, only: [:show, :update, :destroy, :create_version, :revert]
  before_action :check_ownership, only: [:show, :update, :destroy, :create_version, :revert]

  def index
    @rulesets = @project.rulesets.where(user: current_user).by_version
    render json: @rulesets.map { |ruleset| ruleset_json(ruleset) }
  end

  def user_index
    @rulesets = current_user.rulesets.recent.includes(:project)
    render json: @rulesets.map { |ruleset| ruleset_json(ruleset, include_project: true) }
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
    # Create new version instead of updating existing
    new_version = @ruleset.create_new_version(ruleset_params[:content], current_user)
    render json: ruleset_json(new_version, include_content: true)
  rescue => e
    render json: { errors: [e.message] }, status: :unprocessable_entity
  end

  def create_version
    new_version = @ruleset.create_new_version(params[:content], current_user)
    render json: ruleset_json(new_version, include_content: true)
  rescue => e
    render json: { errors: [e.message] }, status: :unprocessable_entity
  end

  def revert
    target_version = @ruleset.version_history.find { |v| v.version == params[:target_version].to_i }
    if target_version
      new_version = @ruleset.create_new_version(target_version.content, current_user)
      render json: {
        message: "Reverted to version #{params[:target_version]}",
        ruleset: ruleset_json(new_version, include_content: true)
      }
    else
      render json: { error: 'Target version not found' }, status: :not_found
    end
  end

  def version_history
    versions = @ruleset.version_history
    render json: versions.map { |v| ruleset_json(v, include_content: false) }
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
    if params[:project_id]
      @ruleset = @project.rulesets.where(user: current_user).find(params[:id])
    else
      @ruleset = current_user.rulesets.find(params[:id])
    end
  end

  def check_ownership
    unless @ruleset.can_be_edited_by?(current_user)
      render json: { error: 'Unauthorized access to ruleset' }, status: :forbidden
    end
  end

  def ruleset_params
    params.require(:ruleset).permit(:content, :is_public)
  end

  def ruleset_json(ruleset, include_content: false, public_view: false, include_project: false)
    json = {
      id: ruleset.id,
      version: ruleset.version,
      uuid: ruleset.uuid,
      is_public: ruleset.is_public,
      title: ruleset.title,
      word_count: ruleset.word_count,
      tech_stack_count: ruleset.tech_stack_count,
      tags: ruleset.tag_array,
      created_at: ruleset.created_at,
      updated_at: ruleset.updated_at,
      latest_version: ruleset.latest_version?
    }

    if include_content
      json[:content] = ruleset.content
    end

    if include_project && ruleset.project
      json[:project] = {
        id: ruleset.project.id,
        name: ruleset.project.name,
        description: ruleset.project.description
      }
    end

    unless public_view
      if ruleset.project
        json[:project] = {
          id: ruleset.project.id,
          name: ruleset.project.name
        }
      end
    end

    json
  end
end
