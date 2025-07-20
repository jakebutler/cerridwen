# frozen_string_literal: true

require 'openai'

class ActiveAgentRulesService
  def initialize(project, user = nil)
    @project = project
    @user = user
    @openai_client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
    @ai_rule_archive_service = AiRuleArchiveService.new
  end

  def generate_ruleset
    return false unless valid_project?

    begin
      # Get community insights from AI Rule Archive
      community_insights = fetch_community_insights

      # Generate LLM-powered ruleset using Active Agent
      ruleset_content = generate_with_active_agent(community_insights)
      
      # Create and save the ruleset
      create_ruleset(ruleset_content)
      
      true
    rescue => e
      Rails.logger.error "ActiveAgent ruleset generation failed: #{e.message}"
      @errors = ["Failed to generate ruleset: #{e.message}"]
      false
    end
  end

  def errors
    @errors || []
  end

  private

  def valid_project?
    @project.present? && 
    @project.description.present? && 
    @project.tech_stack.present? &&
    @project.dev_identity.present?
  end

  def fetch_community_insights
    return { example_rulesets: [], insights: {} } unless @ai_rule_archive_service

    # Fetch relevant example rulesets based on tech stack
    example_rulesets = @ai_rule_archive_service.fetch_relevant_rulesets(@project.tech_stack, limit: 3)
    
    # Extract insights from the fetched rulesets
    insights = @ai_rule_archive_service.extract_insights(example_rulesets)
    
    {
      example_rulesets: example_rulesets,
      insights: insights
    }
  rescue => e
    Rails.logger.warn "Failed to fetch community insights: #{e.message}"
    { example_rulesets: [], insights: {} }
  end

  def generate_with_active_agent(community_insights)
    # Build comprehensive prompt for LLM
    prompt = build_comprehensive_prompt(community_insights)
    
    # Use Active Agent to orchestrate the LLM call
    agent_response = call_active_agent(prompt)
    
    # Process and format the response
    format_ruleset_response(agent_response)
  end

  def build_comprehensive_prompt(community_insights)
    dev_identity_context = build_dev_identity_context
    tech_stack_context = build_tech_stack_context
    community_context = build_community_context(community_insights)
    example_rulesets_context = build_example_rulesets_context(community_insights[:example_rulesets] || [])
    
    <<~PROMPT
      You are an expert software architect and coding mentor. Generate a comprehensive, personalized coding ruleset in Markdown format.

      ## Project Context:
      **Developer Identity**: #{@project.dev_identity}
      #{dev_identity_context}

      **Application Description**: 
      #{@project.description}

      **Technology Stack**: 
      #{@project.tech_stack.join(', ')}
      #{tech_stack_context}

      #{example_rulesets_context}

      #{community_context}

      **Additional Requirements**:
      #{@project.requirements_file_content.present? ? @project.requirements_file_content : 'None specified'}

      ## Instructions:
      Create a detailed, actionable coding ruleset that includes:

      1. **Code Style & Formatting**
         - Language-specific conventions for each technology
         - Naming conventions (variables, functions, classes, files)
         - Indentation, spacing, and structure guidelines

      2. **Architecture & Design Patterns**
         - Recommended patterns for the tech stack
         - File organization and project structure
         - Separation of concerns principles

      3. **Best Practices**
         - Error handling strategies
         - Performance optimization guidelines
         - Security considerations for the tech stack

      4. **Testing Strategy**
         - Testing frameworks and approaches
         - Coverage expectations
         - Test organization patterns

      5. **Documentation Standards**
         - Code commenting guidelines
         - README and documentation requirements
         - API documentation standards

      6. **Development Workflow**
         - Git workflow and commit message standards
         - Code review checklist
         - Deployment considerations

      7. **Technology-Specific Guidelines**
         - Framework-specific best practices
         - Library usage recommendations
         - Configuration management

      Make the ruleset practical, specific, and tailored to the developer's identity and project needs. Use clear examples where helpful.

      Format the response as clean Markdown with proper headers, bullet points, and code examples.
    PROMPT
  end

  def build_dev_identity_context
    case @project.dev_identity
    when 'vibe_coder'
      <<~CONTEXT
        *This developer values creativity, experimentation, and flexible approaches. They prefer:*
        - Creative solutions over rigid patterns
        - Rapid prototyping and iteration
        - Flexible, adaptable code structures
        - Fun, expressive coding styles
        - Learning through experimentation
      CONTEXT
    when 'experienced_dev'
      <<~CONTEXT
        *This developer values professional standards, maintainability, and proven practices. They prefer:*
        - Industry-standard patterns and conventions
        - Robust, maintainable code architecture
        - Comprehensive testing and documentation
        - Performance optimization
        - Scalable, enterprise-ready solutions
      CONTEXT
    else
      ""
    end
  end

  def build_tech_stack_context
    return "" if @project.tech_stack.empty?

    contexts = []
    
    # Add specific guidance for common technologies
    @project.tech_stack.each do |tech|
      case tech.downcase
      when /react/
        contexts << "- React: Focus on hooks, component composition, and modern patterns"
      when /rails/
        contexts << "- Rails: Emphasize convention over configuration, RESTful design"
      when /node/
        contexts << "- Node.js: Async/await patterns, proper error handling, security"
      when /python/
        contexts << "- Python: PEP 8 compliance, type hints, virtual environments"
      when /typescript/
        contexts << "- TypeScript: Strong typing, interface definitions, strict mode"
      when /docker/
        contexts << "- Docker: Multi-stage builds, security scanning, optimization"
      end
    end

    contexts.any? ? "\n**Technology-Specific Notes**:\n#{contexts.join("\n")}" : ""
  end

  def build_example_rulesets_context(example_rulesets)
    return "" if example_rulesets.empty?

    context = "\n## Example Rulesets from Community:\n"
    context += "*Learn from these high-quality community rulesets with similar tech stacks:*\n\n"
    
    example_rulesets.each_with_index do |ruleset, index|
      context += "### Example #{index + 1}: #{ruleset['name'] || 'Community Ruleset'}\n"
      context += "**Technologies**: #{(ruleset['technologies'] || []).join(', ')}\n"
      
      # Include a preview of the ruleset content
      content_preview = ruleset['content']&.strip
      if content_preview.present?
        # Take first 500 characters as preview
        preview = content_preview.length > 500 ? content_preview[0..500] + "..." : content_preview
        context += "\n```\n#{preview}\n```\n\n"
      end
      
      context += "---\n\n"
    end
    
    context += "*Use these examples as inspiration, but tailor your ruleset to the specific project needs.*\n\n"
    context
  end

  def build_community_context(community_insights)
    insights_data = community_insights[:insights] || {}
    return "" if insights_data.empty?

    context = "\n## Community Best Practices:\n"
    context += "*Based on curated community rulesets and best practices:*\n\n"
    
    # Add common patterns
    if insights_data[:common_patterns]&.any?
      context += "**Common Patterns**:\n"
      insights_data[:common_patterns].each { |pattern| context += "- #{pattern}\n" }
      context += "\n"
    end
    
    # Add best practices
    if insights_data[:best_practices]&.any?
      context += "**Best Practices**:\n"
      insights_data[:best_practices].each { |practice| context += "- #{practice}\n" }
      context += "\n"
    end
    
    # Add tech-specific rules
    if insights_data[:tech_specific_rules]&.any?
      context += "**Technology-Specific Guidelines**:\n"
      insights_data[:tech_specific_rules].each do |tech, rules|
        next if rules.empty?
        context += "*#{tech}*:\n"
        rules.each { |rule| context += "  - #{rule}\n" }
      end
      context += "\n"
    end
    
    context
  end

  def call_active_agent(prompt)
    # Use Active Agent to make the OpenAI API call with proper orchestration
    response = @openai_client.chat(
      parameters: {
        model: "gpt-4o",
        messages: [
          {
            role: "system",
            content: "You are an expert software architect and coding mentor. Generate comprehensive, practical coding rulesets in clean Markdown format."
          },
          {
            role: "user", 
            content: prompt
          }
        ],
        max_tokens: 4000,
        temperature: 0.7
      }
    )

    response.dig("choices", 0, "message", "content")
  rescue => e
    Rails.logger.error "OpenAI API call failed: #{e.message}"
    generate_fallback_ruleset
  end

  def format_ruleset_response(content)
    return generate_fallback_ruleset if content.blank?

    # Add metadata header
    formatted_content = "# 🎯 Personalized Coding Ruleset\n\n"
    formatted_content += "*Generated with AI assistance and community best practices*\n\n"
    formatted_content += "**Project**: #{@project.description[0..100]}#{'...' if @project.description.length > 100}\n"
    formatted_content += "**Developer Style**: #{@project.dev_identity.humanize}\n"
    formatted_content += "**Tech Stack**: #{@project.tech_stack.join(', ')}\n"
    formatted_content += "**Generated**: #{Time.current.strftime('%B %d, %Y at %I:%M %p')}\n\n"
    formatted_content += "---\n\n"
    formatted_content += content

    # Ensure proper Markdown formatting
    formatted_content.gsub(/\n{3,}/, "\n\n")
  end

  def generate_fallback_ruleset
    # Fallback content if LLM fails - use the correct service method
    service = RulesGenerationService.new(@project)
    if service.generate_ruleset
      # Get the latest ruleset content that was just created
      latest_ruleset = @project.rulesets.order(:version).last
      latest_ruleset&.content || "# Fallback Ruleset\n\nBasic coding guidelines for your project."
    else
      "# Fallback Ruleset\n\nBasic coding guidelines for your project."
    end
  end

  def create_ruleset(content)
    # Determine version based on user's rulesets for this project
    version = if @user
      (@user.rulesets.where(project: @project).maximum(:version) || 0) + 1
    else
      (@project.rulesets.maximum(:version) || 0) + 1
    end
    
    # Create ruleset with user association
    if @user
      @user.rulesets.create!(
        content: content,
        version: version,
        project: @project
      )
    else
      # Fallback for backward compatibility
      @project.rulesets.create!(
        content: content,
        version: version
      )
    end
  end
end
