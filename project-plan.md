📅 Rules Wizard Development Plan

A vibe-coded hackathon roadmap for building the AI-powered wizard that generates IDE rulesets.

⸻

✅ Milestone 1: Project Setup & Authentication
	•	Initialize new Rails app in API-only mode
	•	Add fly.toml and set up initial Fly.io deployment
	•	Set up PostgreSQL database and connect to Fly.io
	•	Install and configure TailwindCSS with Windsurf IDE
	•	Create User model with Devise (email + password auth)
	•	Add user registration, login, and logout endpoints
	•	Add sessions controller for session management
	•	Scaffold Project and Ruleset models with relations to User
	•	Add environment variables and secrets management for Active Agent and Fly.io
	•	Deploy base skeleton to production on Fly.io

⸻

✅ Milestone 2: Wizard UI Flow
	•	Create multi-step wizard container component
	•	Step 1: Dev identity selection (vibe coder / experienced dev)
	•	Add toggle component for selection
	•	Persist choice in session state
	•	Step 2: Tech stack selection
	•	Build checkbox grid for common frameworks/languages
	•	Add free-text input for unlisted tech
	•	Step 3: App description input
	•	Add large multiline text area
	•	Validate that description is at least 10 words
	•	Step 4: Requirements file input
	•	Allow pasting in markdown
	•	Add drag-and-drop .md file upload support
	•	Parse uploaded text and sanitize
	•	Step 5: Summary and confirmation screen
	•	Display collected inputs for user review
	•	Add back/edit functionality for each step

⸻

✅ Milestone 3: Active Agent + Rule Generation
	•	Add Active Agent SDK and configure credentials
	•	Format input prompts using wizard session data
	•	Include .md file content if provided
	•	Call ai-rules-database API via Active Agent chain
	•	Handle streaming or batch response and parse ruleset
	•	Store generated ruleset in Markdown format
	•	Save ruleset in DB linked to project and user
	•	Display generation success and advance to editing UI

⸻

✅ Milestone 4: Ruleset Display & Editing
	•	Create Markdown editor using TipTap or SimpleMDE
	•	Load ruleset content into editor with live preview
	•	Add “Copy to Clipboard” button with confirmation toast
	•	Add “Download .md” button using Blob
	•	Save edits back to server when user clicks “Save Changes”
	•	Auto-version edited rulesets for history
	•	Show timestamps and metadata for each ruleset

⸻

✅ Milestone 5: Project Dashboard & Sharing
	•	Build dashboard view for logged-in users
	•	List all their saved projects
	•	Show date created and last updated
	•	“Open” and “Delete” buttons per project
	•	Create public-facing sharable ruleset view
	•	URL format: /ruleset/:uuid
	•	Read-only view of final ruleset in Markdown
	•	Add copy link/share UI with preview tooltip
	•	Implement regenerate option on saved projects

⸻

✅ Milestone 6: Polish, Deploy, QA
	•	Add transition animations between wizard steps
	•	Make wizard tone easily swappable via prompt personality key
	•	Polish UI components: spacing, responsive design, fonts
	•	Set up 404, 401, and 500 error handling views
	•	Add basic feedback button or emoji reactions
	•	Implement simple analytics with PostHog or Plausible
	•	Final Fly.io deployment with domain
	•	Manual QA of all wizard flows, auth, save/load flows, share links

⸻

🧪 Post-MVP / Stretch Goals (Optional)
	•	Admin dashboard to manage users and submissions
	•	Role-based access controls for admins
	•	Curate or flag AI-generated rulesets
	•	One-click IDE integration via plugin
	•	Community sharing of ruleset templates
	•	A/B test wizard tones (e.g., serious vs chaotic wizard)