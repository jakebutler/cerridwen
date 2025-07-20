# AI Rule Archive Service
# Integrates with the AI Rule Archive API to fetch existing rulesets
# and enhance our generated rulesets with community best practices

require 'net/http'
require 'json'

class AiRuleArchiveService
  BASE_URL = ENV['AI_RULE_ARCHIVE_BASE_URL'] || 'https://your-deployed-app.replit.app/api/v1'
  API_KEY = ENV['AI_RULE_ARCHIVE_API_KEY']

  attr_reader :errors

  def initialize
    @errors = []
  end

  # Fetch relevant rulesets based on technologies
  def fetch_relevant_rulesets(technologies, limit: 5)
    return [] unless api_configured?

    rulesets = []
    
    technologies.each do |tech|
      begin
        tech_rulesets = fetch_rulesets_by_technology(tech, limit: 2)
        rulesets.concat(tech_rulesets)
      rescue StandardError => e
        Rails.logger.warn "Failed to fetch rulesets for #{tech}: #{e.message}"
        @errors << "Failed to fetch rulesets for #{tech}"
      end
    end

    # Remove duplicates and limit total results
    rulesets.uniq { |r| r['id'] }.first(limit)
  end

  # Search for rulesets by query
  def search_rulesets(query, limit: 10)
    return [] unless api_configured?

    begin
      params = {
        search: query,
        limit: limit
      }
      
      response = make_api_request('/rulesets', params)
      response['data'] || []
    rescue StandardError => e
      Rails.logger.error "AI Rule Archive search failed: #{e.message}"
      @errors << "Search failed: #{e.message}"
      []
    end
  end

  # Get all available technologies
  def fetch_technologies
    return [] unless api_configured?

    begin
      response = make_api_request('/technologies')
      response['data'] || []
    rescue StandardError => e
      Rails.logger.error "Failed to fetch technologies: #{e.message}"
      @errors << "Failed to fetch technologies"
      []
    end
  end

  # Get a specific ruleset by ID
  def fetch_ruleset(id)
    return nil unless api_configured?

    begin
      response = make_api_request("/rulesets/#{id}")
      response['data']
    rescue StandardError => e
      Rails.logger.error "Failed to fetch ruleset #{id}: #{e.message}"
      @errors << "Failed to fetch ruleset #{id}"
      nil
    end
  end

  # Extract key insights from fetched rulesets for AI enhancement
  def extract_insights(rulesets)
    return {} if rulesets.empty?

    insights = {
      common_patterns: [],
      best_practices: [],
      tech_specific_rules: {},
      popular_tools: [],
      security_practices: [],
      testing_strategies: []
    }

    rulesets.each do |ruleset|
      content = ruleset['content'] || ''
      technologies = ruleset['technologies'] || []

      # Extract common patterns
      insights[:common_patterns].concat(extract_patterns(content))
      
      # Extract best practices
      insights[:best_practices].concat(extract_best_practices(content))
      
      # Extract tech-specific rules
      technologies.each do |tech|
        insights[:tech_specific_rules][tech] ||= []
        insights[:tech_specific_rules][tech].concat(extract_tech_rules(content, tech))
      end

      # Extract security and testing info
      insights[:security_practices].concat(extract_security_practices(content))
      insights[:testing_strategies].concat(extract_testing_strategies(content))
    end

    # Remove duplicates and limit results
    insights.each do |key, value|
      if value.is_a?(Array)
        insights[key] = value.uniq.first(10)
      elsif value.is_a?(Hash)
        value.each { |k, v| value[k] = v.uniq.first(5) if v.is_a?(Array) }
      end
    end

    insights
  end

  private

  def api_configured?
    if API_KEY.blank? || API_KEY == 'your_ai_rule_archive_api_key_here'
      Rails.logger.info "AI Rule Archive API key not configured, skipping external ruleset fetch"
      return false
    end
    true
  end

  def fetch_rulesets_by_technology(technology, limit: 5)
    params = {
      technology: technology,
      limit: limit
    }
    
    response = make_api_request('/rulesets', params)
    response['data'] || []
  end

  def make_api_request(endpoint, params = {})
    uri = URI("#{BASE_URL}#{endpoint}")
    uri.query = URI.encode_www_form(params) unless params.empty?

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == 'https'
    http.read_timeout = 10
    http.open_timeout = 5

    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "Bearer #{API_KEY}"
    request['Content-Type'] = 'application/json'

    response = http.request(request)

    case response.code.to_i
    when 200
      JSON.parse(response.body)
    when 401
      raise "Unauthorized: Invalid API key"
    when 429
      raise "Rate limit exceeded"
    when 404
      raise "Endpoint not found"
    else
      raise "API request failed with status #{response.code}: #{response.body}"
    end
  end

  def extract_patterns(content)
    patterns = []
    
    # Look for common patterns in the content
    patterns << "Use TypeScript for type safety" if content.match?(/typescript|type.?safety/i)
    patterns << "Implement error boundaries" if content.match?(/error.?boundar/i)
    patterns << "Use functional components" if content.match?(/functional.?component/i)
    patterns << "Follow single responsibility principle" if content.match?(/single.?responsibility/i)
    patterns << "Use dependency injection" if content.match?(/dependency.?injection/i)
    patterns << "Implement proper logging" if content.match?(/logging|log\s/i)
    
    patterns
  end

  def extract_best_practices(content)
    practices = []
    
    # Extract best practices mentioned in the content
    practices << "Write comprehensive tests" if content.match?(/test|testing/i)
    practices << "Use consistent naming conventions" if content.match?(/naming.?convention/i)
    practices << "Implement code reviews" if content.match?(/code.?review/i)
    practices << "Use version control effectively" if content.match?(/version.?control|git/i)
    practices << "Document your code" if content.match?(/document|documentation/i)
    practices << "Follow security best practices" if content.match?(/security/i)
    
    practices
  end

  def extract_tech_rules(content, technology)
    rules = []
    tech_lower = technology.downcase
    
    case tech_lower
    when 'react'
      rules << "Use hooks instead of class components" if content.match?(/hooks?/i)
      rules << "Implement proper state management" if content.match?(/state.?management/i)
      rules << "Use React.memo for performance" if content.match?(/react\.memo|memo/i)
    when 'python'
      rules << "Follow PEP 8 style guide" if content.match?(/pep.?8/i)
      rules << "Use type hints" if content.match?(/type.?hint/i)
      rules << "Use virtual environments" if content.match?(/virtual.?env|venv/i)
    when 'javascript', 'typescript'
      rules << "Use modern ES6+ syntax" if content.match?(/es6|modern.?javascript/i)
      rules << "Implement proper async handling" if content.match?(/async|await|promise/i)
      rules << "Use strict mode" if content.match?(/strict.?mode/i)
    when 'docker'
      rules << "Use multi-stage builds" if content.match?(/multi.?stage/i)
      rules << "Minimize image size" if content.match?(/image.?size|minimize/i)
      rules << "Use specific tags" if content.match?(/specific.?tag|latest/i)
    end
    
    rules
  end

  def extract_security_practices(content)
    practices = []
    
    practices << "Validate all inputs" if content.match?(/input.?validation|validate.?input/i)
    practices << "Use HTTPS everywhere" if content.match?(/https/i)
    practices << "Implement proper authentication" if content.match?(/authentication|auth/i)
    practices << "Sanitize user data" if content.match?(/sanitize|sanitization/i)
    practices << "Use environment variables for secrets" if content.match?(/environment.?variable|env.*secret/i)
    practices << "Regular security audits" if content.match?(/security.?audit/i)
    
    practices
  end

  def extract_testing_strategies(content)
    strategies = []
    
    strategies << "Unit testing for business logic" if content.match?(/unit.?test/i)
    strategies << "Integration testing for APIs" if content.match?(/integration.?test/i)
    strategies << "End-to-end testing" if content.match?(/e2e|end.?to.?end/i)
    strategies << "Test-driven development" if content.match?(/tdd|test.?driven/i)
    strategies << "Mock external dependencies" if content.match?(/mock|mocking/i)
    strategies << "Performance testing" if content.match?(/performance.?test/i)
    
    strategies
  end
end
