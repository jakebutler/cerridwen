# Rules Generation Service
# This service handles the generation of AI-powered coding rulesets
# Will be integrated with Active Agent once environment is properly configured

class RulesGenerationService
  attr_reader :project, :errors

  def initialize(project)
    @project = project
    @errors = []
  end

  def generate_ruleset
    begin
      # Validate project data
      return false unless validate_project_data

      # Build prompt context from project data
      prompt_context = build_prompt_context

      # Generate rules using LLM (placeholder for Active Agent integration)
      generated_content = generate_ai_rules(prompt_context)

      # Create and save the ruleset
      create_ruleset(generated_content)

      true
    rescue StandardError => e
      @errors << "Generation failed: #{e.message}"
      Rails.logger.error "Rules generation error: #{e.message}"
      false
    end
  end

  private

  def validate_project_data
    if project.description.blank?
      @errors << "Project description is required"
      return false
    end

    if project.tech_stack.blank?
      @errors << "Tech stack is required"
      return false
    end

    if project.dev_identity.blank?
      @errors << "Developer identity is required"
      return false
    end

    true
  end

  def build_prompt_context
    {
      dev_identity: project.dev_identity,
      tech_stack: project.tech_stack,
      description: project.description,
      requirements: project.requirements_content,
      project_name: project.name,
      created_at: project.created_at
    }
  end

  def generate_ai_rules(context)
    # Fetch relevant rulesets from AI Rule Archive for enhancement
    archive_service = AiRuleArchiveService.new
    relevant_rulesets = archive_service.fetch_relevant_rulesets(context[:tech_stack], limit: 5)
    insights = archive_service.extract_insights(relevant_rulesets)
    
    # Log AI Rule Archive integration status
    if relevant_rulesets.any?
      Rails.logger.info "Enhanced ruleset generation with #{relevant_rulesets.length} community rulesets"
    else
      Rails.logger.info "Generating ruleset without external enhancement (API not configured or unavailable)"
    end
    
    # Generate rules based on dev identity with AI Rule Archive enhancement
    case context[:dev_identity]
    when 'vibe_coder'
      generate_vibe_coder_rules(context, insights)
    when 'experienced_dev'
      generate_experienced_dev_rules(context, insights)
    else
      generate_default_rules(context, insights)
    end
  end

  def generate_vibe_coder_rules(context, insights = {})
    tech_list = context[:tech_stack].join(', ')
    
    <<~MARKDOWN
      # 🎨 Vibe Coder Rules for #{context[:project_name]}

      ## Project Overview
      #{context[:description]}

      ## Tech Stack
      #{tech_list}

      ## Coding Philosophy
      - **Creativity First**: Experiment with new approaches and don't be afraid to try unconventional solutions
      - **Fun & Flow**: Keep coding enjoyable and maintain a good development flow
      - **Rapid Prototyping**: Build quickly, iterate often, and refine as you go
      - **Learn by Doing**: Embrace learning through experimentation and hands-on experience

      ## Code Style Guidelines
      - Write expressive, readable code that tells a story
      - Use meaningful variable and function names that reflect their purpose
      - Comment your creative solutions and explain the "why" behind unusual approaches
      - Keep functions focused but don't over-engineer early iterations

      ## Development Practices
      - Start with working code, then refactor for elegance
      - Use version control to experiment fearlessly with branches
      - Document interesting discoveries and lessons learned
      - Share cool findings with the team

      ## Tech-Specific Guidelines
      #{generate_tech_specific_guidelines(context[:tech_stack], 'creative')}
      #{generate_community_insights_section(insights, 'creative')}

      ## Quality Standards
      - Code should work reliably, even if the approach is unconventional
      - Test the happy path thoroughly, edge cases can be refined later
      - Performance optimization comes after functionality is proven
      - Security basics are non-negotiable, creativity doesn't compromise safety

      #{context[:requirements].present? ? "## Additional Requirements\n#{context[:requirements]}" : ""}

      ---
      *Generated on #{Time.current.strftime('%B %d, %Y')} for a creative, experimental development approach.*
    MARKDOWN
  end

  def generate_experienced_dev_rules(context, insights = {})
    tech_list = context[:tech_stack].join(', ')
    
    <<~MARKDOWN
      # ⚡ Professional Development Rules for #{context[:project_name]}

      ## Project Overview
      #{context[:description]}

      ## Tech Stack
      #{tech_list}

      ## Development Philosophy
      - **Best Practices First**: Follow established patterns and industry standards
      - **Maintainable Code**: Write code that your future self and teammates will thank you for
      - **Comprehensive Testing**: Test-driven development with thorough coverage
      - **Documentation**: Clear, comprehensive documentation for all components

      ## Code Quality Standards
      - Follow SOLID principles and established design patterns
      - Implement comprehensive error handling and logging
      - Use consistent naming conventions and code formatting
      - Write self-documenting code with strategic comments

      ## Architecture Guidelines
      - Design for scalability and maintainability from the start
      - Implement proper separation of concerns
      - Use dependency injection and inversion of control
      - Plan for configuration management and environment differences

      ## Development Workflow
      - Feature branch workflow with code reviews
      - Continuous integration and automated testing
      - Comprehensive documentation for all APIs and components
      - Regular refactoring and technical debt management

      ## Tech-Specific Guidelines
      #{generate_tech_specific_guidelines(context[:tech_stack], 'professional')}
      #{generate_community_insights_section(insights, 'professional')}

      ## Security & Performance
      - Implement security best practices from day one
      - Performance monitoring and optimization strategies
      - Proper input validation and sanitization
      - Regular security audits and dependency updates

      ## Testing Strategy
      - Unit tests for all business logic
      - Integration tests for critical workflows
      - End-to-end tests for user journeys
      - Performance and load testing for production readiness

      #{context[:requirements].present? ? "## Additional Requirements\n#{context[:requirements]}" : ""}

      ---
      *Generated on #{Time.current.strftime('%B %d, %Y')} for professional, enterprise-grade development.*
    MARKDOWN
  end

  def generate_default_rules(context, insights = {})
    tech_list = context[:tech_stack].join(', ')
    
    <<~MARKDOWN
      # 📋 Development Rules for #{context[:project_name]}

      ## Project Overview
      #{context[:description]}

      ## Tech Stack
      #{tech_list}

      ## General Guidelines
      - Write clean, readable, and maintainable code
      - Follow established conventions for your tech stack
      - Implement appropriate testing strategies
      - Document important decisions and complex logic

      ## Tech-Specific Guidelines
      #{generate_tech_specific_guidelines(context[:tech_stack], 'balanced')}

      #{context[:requirements].present? ? "## Additional Requirements\n#{context[:requirements]}" : ""}

      ---
      *Generated on #{Time.current.strftime('%B %d, %Y')}*
    MARKDOWN
  end

  def generate_tech_specific_guidelines(tech_stack, style)
    guidelines = []

    tech_stack.each do |tech|
      case tech.downcase
      when 'javascript', 'typescript'
        guidelines << javascript_guidelines(style)
      when 'react', 'vue.js', 'angular'
        guidelines << frontend_framework_guidelines(tech, style)
      when 'node.js', 'express.js'
        guidelines << nodejs_guidelines(style)
      when 'python', 'django', 'flask'
        guidelines << python_guidelines(style)
      when 'ruby', 'ruby on rails'
        guidelines << ruby_guidelines(style)
      when 'docker', 'kubernetes'
        guidelines << containerization_guidelines(style)
      end
    end

    guidelines.join("\n\n")
  end

  def javascript_guidelines(style)
    case style
    when 'creative'
      "### JavaScript/TypeScript\n- Embrace modern ES6+ features and experiment with new APIs\n- Use functional programming concepts when they make code more expressive\n- Try different approaches to async handling (promises, async/await, observables)"
    when 'professional'
      "### JavaScript/TypeScript\n- Use TypeScript for type safety and better developer experience\n- Implement ESLint and Prettier for consistent code formatting\n- Follow established patterns for error handling and async operations"
    else
      "### JavaScript/TypeScript\n- Use modern ES6+ syntax and features\n- Implement proper error handling for async operations\n- Follow consistent naming and formatting conventions"
    end
  end

  def frontend_framework_guidelines(tech, style)
    case style
    when 'creative'
      "### #{tech}\n- Experiment with component composition patterns\n- Try different state management approaches\n- Use the latest features and hooks creatively"
    when 'professional'
      "### #{tech}\n- Follow component design patterns and best practices\n- Implement proper state management architecture\n- Use established testing patterns for components"
    else
      "### #{tech}\n- Create reusable, well-structured components\n- Implement appropriate state management\n- Follow framework-specific best practices"
    end
  end

  def nodejs_guidelines(style)
    case style
    when 'creative'
      "### Node.js\n- Experiment with different middleware patterns\n- Try new npm packages and tools\n- Use streams and events creatively for data processing"
    when 'professional'
      "### Node.js\n- Implement proper error handling and logging\n- Use established patterns for API design\n- Follow security best practices for server-side code"
    else
      "### Node.js\n- Structure your application with clear separation of concerns\n- Implement proper error handling\n- Use middleware effectively"
    end
  end

  def python_guidelines(style)
    case style
    when 'creative'
      "### Python\n- Explore Python's rich ecosystem and libraries\n- Use list comprehensions and generators creatively\n- Experiment with decorators and context managers"
    when 'professional'
      "### Python\n- Follow PEP 8 style guidelines strictly\n- Implement comprehensive type hints\n- Use virtual environments and dependency management"
    else
      "### Python\n- Write clean, readable Python code\n- Use appropriate data structures and algorithms\n- Follow Python conventions and idioms"
    end
  end

  def ruby_guidelines(style)
    case style
    when 'creative'
      "### Ruby\n- Embrace Ruby's expressiveness and metaprogramming\n- Experiment with blocks, procs, and lambdas\n- Use Ruby's flexibility to create elegant solutions"
    when 'professional'
      "### Ruby\n- Follow Ruby style guides and best practices\n- Implement proper testing with RSpec or Minitest\n- Use Rails conventions and patterns consistently"
    else
      "### Ruby\n- Write idiomatic Ruby code\n- Use appropriate design patterns\n- Follow established Ruby and Rails conventions"
    end
  end

  def containerization_guidelines(style)
    case style
    when 'creative'
      "### Docker/Kubernetes\n- Experiment with different containerization strategies\n- Try multi-stage builds and optimization techniques\n- Explore different orchestration patterns"
    when 'professional'
      "### Docker/Kubernetes\n- Follow security best practices for containers\n- Implement proper health checks and monitoring\n- Use established patterns for CI/CD with containers"
    else
      "### Docker/Kubernetes\n- Create efficient, secure container images\n- Implement proper configuration management\n- Follow containerization best practices"
    end
  end

  def create_ruleset(content)
    ruleset = project.rulesets.create!(
      version: next_version_number,
      content: content,
      status: 'generated',
      generated_at: Time.current,
      metadata: {
        generation_method: 'service_placeholder',
        tech_stack: project.tech_stack,
        dev_identity: project.dev_identity,
        word_count: content.split.length
      }
    )

    Rails.logger.info "Generated ruleset #{ruleset.id} for project #{project.id}"
    ruleset
  end

  def next_version_number
    last_version = project.rulesets.maximum(:version) || 0
    last_version + 1
  end

  def generate_community_insights_section(insights, style)
    return "" if insights.empty? || insights[:best_practices].blank?

    section = "\n\n### 🌟 Community Best Practices\n"
    section += "*Enhanced with insights from the AI Rule Archive community*\n\n"

    # Add best practices based on style
    if insights[:best_practices].any?
      practices = case style
      when 'creative'
        insights[:best_practices].select { |p| p.match?(/creative|experiment|flexible/i) }
      when 'professional'
        insights[:best_practices].select { |p| p.match?(/comprehensive|enterprise|professional/i) }
      else
        insights[:best_practices]
      end

      if practices.any?
        section += practices.first(5).map { |practice| "- #{practice}" }.join("\n")
        section += "\n\n"
      end
    end

    # Add tech-specific insights
    if insights[:tech_specific_rules].any?
      section += "#### Technology-Specific Insights:\n"
      insights[:tech_specific_rules].each do |tech, rules|
        if rules.any?
          section += "**#{tech}:**\n"
          section += rules.first(3).map { |rule| "- #{rule}" }.join("\n")
          section += "\n\n"
        end
      end
    end

    # Add security practices for professional style
    if style == 'professional' && insights[:security_practices].any?
      section += "#### Security Insights:\n"
      section += insights[:security_practices].first(3).map { |practice| "- #{practice}" }.join("\n")
      section += "\n\n"
    end

    # Add testing strategies
    if insights[:testing_strategies].any?
      section += "#### Testing Insights:\n"
      section += insights[:testing_strategies].first(3).map { |strategy| "- #{strategy}" }.join("\n")
      section += "\n"
    end

    section
  end
end
