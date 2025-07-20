# Rules Wizard (Cerridwen)

*"Describe your app. Get magical, personalized AI rules."*

Rules Wizard is a playful, AI-powered frontend agent that guides developers through describing their app and automatically generates custom .md rulesets for use in AI-assisted IDEs like Cursor, Windsurf, or GitHub Copilot.

## 🎯 Purpose

As LLM-based dev tools become ubiquitous, developers need smarter, context-aware rulesets to fine-tune their IDE assistants. But setting these up manually is tedious. Rules Wizard solves this with a sleek, guided experience powered by Active Agent and backed by an extensible ai-rules-database.

## ✨ Features

- **Guided Wizard Flow**: Step-by-step questions to understand your app and tech stack
- **AI-Powered Generation**: Uses Active Agent to create personalized rulesets
- **Project Persistence**: Save, revisit, and edit your generated rulesets
- **Easy Sharing**: Shareable public URLs for your rulesets
- **Multiple Export Options**: Download .md files or copy to clipboard
- **Vibe-Coded Experience**: Built entirely in Windsurf with a delightful UX

## 🛠 Tech Stack

- **Frontend**: Windsurf + TailwindCSS
- **Backend**: Ruby on Rails (API mode)
- **Authentication**: Devise or Sorcery
- **AI Agent**: Active Agent
- **Deployment**: Fly.io
- **Rules Source**: ai-rules-database
- **Markdown Editor**: TipTap or SimpleMDE
- **File Upload**: Active Storage or Uppy

## 🚀 Getting Started

### Prerequisites

- Ruby 3.2+
- Node.js 18+
- PostgreSQL
- Fly.io CLI (for deployment)

### Development Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/jakebutler/cerridwen.git
   cd cerridwen
   ```

2. Install dependencies:
   ```bash
   bundle install
   npm install
   ```

3. Set up the database:
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. Configure environment variables:
   ```bash
   cp .env.example .env
   # Edit .env with your Active Agent and other API keys
   ```

5. Start the development server:
   ```bash
   rails server
   ```

## 📋 Development Milestones

See [project-plan.md](project-plan.md) for detailed development roadmap.

### Current Status: Milestone 1 - Project Setup & Authentication
- [ ] Initialize Rails app in API-only mode
- [ ] Set up Fly.io deployment
- [ ] Configure PostgreSQL database
- [ ] Install and configure TailwindCSS
- [ ] Implement user authentication with Devise
- [ ] Create core models (User, Project, Ruleset)
- [ ] Deploy base skeleton to production

## 📖 Documentation

- [Product Requirements Document](prd.md) - Detailed feature specifications
- [Project Plan](project-plan.md) - Development roadmap and milestones
- [Coding Rules](cerridwen.windsurfrules) - AI coding assistant rules for this project

## 🎯 Success Metrics

- Wizard completion rate: ≥ 70%
- Average rule generation time: < 10s
- Return visits to saved projects: ≥ 50%
- User NPS: ≥ 7

## 🤝 Contributing

This project follows XP-oriented development practices with TDD/BDD. See our [coding standards](cerridwen.windsurfrules) for detailed guidelines.

## 📄 License

See [LICENSE](LICENSE) file for details.
