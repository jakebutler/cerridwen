# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create a test user for development
if Rails.env.development?
  user = User.find_or_create_by(email: 'test@example.com') do |u|
    u.password = 'password123'
    u.password_confirmation = 'password123'
  end

  # Create a sample project
  project = user.projects.find_or_create_by(name: 'Sample Ruby on Rails App') do |p|
    p.description = 'A sample Ruby on Rails application for testing the Rules Wizard'
    p.tech_stack = ['Ruby on Rails', 'PostgreSQL', 'TailwindCSS']
    p.dev_identity = 'experienced_dev'
    p.requirements_file_content = '# Sample requirements\n- Use Ruby on Rails 7\n- Implement user authentication\n- Follow MVC pattern'
  end

  # Create a sample ruleset
  project.rulesets.find_or_create_by(version: 1) do |r|
    r.content = <<~MARKDOWN
      # Ruby on Rails Development Rules

      ## Architecture
      - Follow MVC pattern strictly
      - Use service objects for complex business logic
      - Keep controllers thin

      ## Code Style
      - Use snake_case for variables and methods
      - Use PascalCase for classes and modules
      - Follow Ruby community conventions

      ## Testing
      - Write comprehensive RSpec tests
      - Use factories for test data
      - Mock external API calls

      ## Security
      - Sanitize all user inputs
      - Use parameterized queries
      - Implement proper authentication
    MARKDOWN
    r.is_public = true
  end

  puts "✅ Created development seed data:"
  puts "   - User: #{user.email}"
  puts "   - Project: #{project.name}"
  puts "   - Ruleset: Version #{project.latest_ruleset&.version}"
end
