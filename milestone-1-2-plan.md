# 🚀 Milestone 1 & 2 Execution Plan
*Rules Wizard Development - First Two Milestones*

## 📋 Milestone 1: Project Setup & Authentication

### Phase 1A: Rails Foundation (Day 1)
**Estimated Time: 4-6 hours**

1. **Initialize Rails API Application**
   ```bash
   rails new . --api --database=postgresql --skip-test
   cd cerridwen
   ```
   - Configure for API-only mode
   - Set up CORS for frontend requests
   - Add essential gems to Gemfile

2. **Database Setup**
   ```bash
   rails db:create
   rails db:migrate
   ```
   - Configure PostgreSQL connection
   - Set up database.yml for development/production
   - Test local database connectivity

3. **Essential Gems Installation**
   ```ruby
   # Add to Gemfile:
   gem 'devise'           # Authentication
   gem 'rack-cors'        # CORS handling
   gem 'dotenv-rails'     # Environment variables
   gem 'active_storage'   # File uploads
   gem 'image_processing' # Image processing
   ```

### Phase 1B: Authentication System (Day 1-2)
**Estimated Time: 3-4 hours**

4. **Devise Setup**
   ```bash
   rails generate devise:install
   rails generate devise User
   rails db:migrate
   ```
   - Configure Devise for API mode
   - Add email/password authentication
   - Set up JWT tokens for session management

5. **User Model Enhancement**
   ```ruby
   # Add to User model:
   - email (from Devise)
   - encrypted_password (from Devise)
   - created_at/updated_at
   ```

6. **Authentication Controllers**
   ```bash
   rails generate controller Api::V1::Sessions
   rails generate controller Api::V1::Registrations
   ```
   - Create login/logout endpoints
   - Add registration endpoint
   - Implement password reset flow

### Phase 1C: Core Models (Day 2)
**Estimated Time: 2-3 hours**

7. **Project Model**
   ```bash
   rails generate model Project user:references name:string description:text tech_stack:text dev_identity:string
   ```
   - belongs_to :user
   - has_many :rulesets
   - Validations for required fields

8. **Ruleset Model**
   ```bash
   rails generate model Ruleset project:references content:text version:integer is_public:boolean uuid:string
   ```
   - belongs_to :project
   - Generate UUID for sharing
   - Version tracking for edits

### Phase 1D: Fly.io Deployment Setup (Day 2-3)
**Estimated Time: 2-3 hours**

9. **Fly.io Configuration**
   ```bash
   fly launch
   ```
   - Create fly.toml configuration
   - Set up PostgreSQL on Fly.io
   - Configure environment variables/secrets

10. **Initial Deployment**
    ```bash
    fly deploy
    ```
    - Deploy base Rails API
    - Test authentication endpoints
    - Verify database connectivity

---

## 🎨 Milestone 2: Wizard UI Flow

### Phase 2A: Frontend Foundation (Day 3-4)
**Estimated Time: 4-5 hours**

1. **TailwindCSS Setup**
   ```bash
   npm install -D tailwindcss @tailwindcss/forms @tailwindcss/typography
   npx tailwindcss init
   ```
   - Configure Tailwind with Rails asset pipeline
   - Set up custom color scheme
   - Add responsive design utilities

2. **Wizard Container Component**
   - Create multi-step wizard layout
   - Add progress indicator
   - Implement step navigation (next/back)
   - Session state management

3. **Base UI Components**
   - Button components (primary, secondary)
   - Input field components
   - Card/container layouts
   - Loading states and animations

### Phase 2B: Wizard Steps Implementation (Day 4-5)
**Estimated Time: 6-8 hours**

4. **Step 1: Dev Identity Selection**
   ```javascript
   // Component features:
   - Toggle between "Vibe Coder" and "Experienced Dev"
   - Visual personality indicators
   - Store choice in session
   ```

5. **Step 2: Tech Stack Selection**
   ```javascript
   // Component features:
   - Checkbox grid for popular frameworks
   - Categories: Frontend, Backend, Database, etc.
   - Free-text input for unlisted technologies
   - Multi-select with visual tags
   ```

6. **Step 3: App Description**
   ```javascript
   // Component features:
   - Large multiline textarea
   - Character count indicator
   - Validation (minimum 10 words)
   - Auto-save draft functionality
   ```

7. **Step 4: Requirements File Input**
   ```javascript
   // Component features:
   - Tabbed interface: "Paste Text" vs "Upload File"
   - Drag-and-drop file upload area
   - Markdown syntax highlighting
   - File validation (.md files only)
   - Text sanitization
   ```

8. **Step 5: Summary & Confirmation**
   ```javascript
   // Component features:
   - Review all collected inputs
   - Edit buttons for each section
   - Final confirmation before generation
   - Loading state for AI processing
   ```

### Phase 2C: Frontend-Backend Integration (Day 5-6)
**Estimated Time: 3-4 hours**

9. **API Endpoints for Wizard**
   ```ruby
   # Routes to create:
   POST /api/v1/projects          # Create new project
   PATCH /api/v1/projects/:id     # Update project data
   POST /api/v1/projects/:id/generate # Trigger ruleset generation
   ```

10. **Session Management**
    - Store wizard progress in browser session
    - Auto-save functionality
    - Resume incomplete wizards
    - Clear session on completion

11. **File Upload Handling**
    - Active Storage integration
    - File type validation
    - Size limits and security checks
    - Markdown parsing and sanitization

---

## 🧪 Testing Strategy

### Unit Tests (Throughout Development)
- Model validations and associations
- Authentication flow testing
- File upload security testing
- API endpoint testing

### Integration Tests
- Complete wizard flow testing
- Authentication integration
- Database persistence testing
- File upload end-to-end testing

### Manual QA Checklist
- [ ] User registration/login works
- [ ] Wizard steps flow correctly
- [ ] Data persists between steps
- [ ] File upload handles edge cases
- [ ] Responsive design on mobile/desktop
- [ ] Error handling displays properly

---

## 📦 Deliverables

### Milestone 1 Complete:
- ✅ Rails API with authentication
- ✅ User, Project, Ruleset models
- ✅ Deployed to Fly.io
- ✅ Database configured and connected

### Milestone 2 Complete:
- ✅ Complete 5-step wizard UI
- ✅ TailwindCSS styling system
- ✅ File upload functionality
- ✅ Session state management
- ✅ Frontend-backend integration

---

## 🎯 Success Criteria

**Milestone 1:**
- User can register/login successfully
- Database models save data correctly
- Application deploys to Fly.io without errors
- Authentication endpoints return proper responses

**Milestone 2:**
- User can complete entire wizard flow
- All form data persists correctly
- File uploads work securely
- UI is responsive and polished
- Ready for AI integration (Milestone 3)

---

## 🚨 Risk Mitigation

**Technical Risks:**
- **Fly.io deployment issues**: Test early and often
- **File upload security**: Implement strict validation
- **Session management**: Use secure, encrypted sessions

**Timeline Risks:**
- **Scope creep**: Stick to MVP features only
- **UI polish time**: Focus on functionality first
- **Integration complexity**: Test components individually

**Next Steps:**
After completing these milestones, we'll be ready for Milestone 3 (Active Agent integration) and Milestone 4 (Ruleset editing).
