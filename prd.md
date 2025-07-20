# Cerridwen: AI-Powered Rules Wizard - Product Requirements Document

## 🎯 **Product Overview**

Cerridwen is an AI-powered web application that generates personalized coding rulesets for developers. The application combines community best practices from the AI Rule Archive with OpenAI's GPT-4o to create comprehensive, tailored coding standards based on a developer's identity, technology stack, and project requirements.

## 🚀 **Core Value Proposition**

- **Personalized AI Generation**: Creates custom coding rulesets using advanced AI and community insights
- **Community-Driven**: Leverages real-world examples from the AI Rule Archive API
- **Professional Workflow**: Intuitive 5-step wizard with loading states and results management
- **User Management**: Complete authentication system with credit-based usage and admin controls
- **Ruleset Library**: Personal collection with versioning, editing, and organization features

## 👥 **Target Users**

### **Primary Users**
- **Individual Developers**: Seeking personalized coding standards for projects
- **Development Teams**: Establishing consistent coding practices
- **Technical Leads**: Creating team-specific guidelines

### **Secondary Users**
- **Platform Administrators**: Managing users, credits, and system oversight
- **Organizations**: Standardizing development practices across teams

## ✨ **Core Features**

### **1. AI-Powered Ruleset Generation**
- **5-Step Wizard Interface**: Developer Identity → Tech Stack → Description → Requirements → Summary
- **AI Integration**: OpenAI GPT-4o with community examples from AI Rule Archive
- **Loading States**: Professional progress indicators during AI processing
- **Results Display**: Complete ruleset with statistics (word count, version, tech stack)
- **Export Options**: Copy to clipboard and download as Markdown

### **2. User Authentication & Management**
- **Self-Registration**: Email/password authentication via Devise
- **Session Management**: Rails-based session authentication
- **User Profiles**: Personal dashboard with credit balance and recent activity
- **No Email Verification**: Streamlined MVP registration process

### **3. Credit System**
- **Initial Credits**: New users receive 10 credits upon registration
- **Usage Model**: 1 credit per successful ruleset generation
- **Credit Deduction**: Only charged on successful completion
- **Zero Credits Handling**: Clear messaging and disabled generation when out of credits
- **Transaction History**: Complete audit trail of credit usage and grants
- **Admin Unlimited**: Administrators have unlimited credits (usage tracked)

### **4. Admin Dashboard**
- **User Management**: View all registered users and their credit status
- **Credit Administration**: Grant additional credits to individual users
- **Usage Analytics**: Track credit consumption and generation patterns
- **Admin Designation**: Environment variable-based admin identification
- **Dashboard Toggle**: Simple header toggle between admin view and wizard
- **Activity Monitoring**: Credit transaction history and user activity logs

### **5. Ruleset Management**
- **Automatic Saving**: Rulesets saved immediately upon successful generation
- **Personal Library**: Private collection of user-generated rulesets
- **Version Control**: Edit existing rulesets with full version history
- **Revert Capability**: Restore previous versions of edited rulesets
- **Technology Tags**: Auto-generated tags based on tech stack for organization
- **Search & Filter**: Find rulesets by tags, creation date, or content

## 🏗️ **Technical Architecture**

### **Backend**
- **Framework**: Ruby on Rails 7.2.2.1 API
- **Database**: PostgreSQL with comprehensive data modeling
- **Authentication**: Devise with Rails sessions
- **AI Integration**: OpenAI GPT-4o API
- **External APIs**: AI Rule Archive for community examples
- **Services**: Modular service objects for business logic

### **Frontend**
- **Wizard Interface**: Alpine.js with TailwindCSS
- **Dashboard Views**: Rails ERB templates with responsive design
- **State Management**: Alpine.js reactive data binding
- **Styling**: TailwindCSS utility-first framework
- **User Experience**: Loading states, error handling, and feedback

### **Database Schema**
- **Users**: Credits, admin flags, authentication data
- **Projects**: Wizard input data and metadata
- **Rulesets**: Generated content, versioning, user association
- **Credit Transactions**: Usage history and admin grants
- **Ruleset Versions**: Edit history and revert capability

## 📊 **User Flows**

### **New User Registration**
1. User visits application
2. Clicks "Sign Up" and provides email/password
3. Account created with 10 initial credits
4. Redirected to user dashboard

### **Ruleset Generation**
1. User clicks "Create New Ruleset" from dashboard
2. Completes 5-step wizard (identity, tech stack, description, requirements, summary)
3. Clicks "Generate Rules" (if sufficient credits)
4. Loading overlay shows AI processing steps
5. Results page displays generated ruleset with actions
6. Ruleset automatically saved to user's library
7. Credit deducted upon successful completion

### **Ruleset Management**
1. User views personal library from dashboard
2. Selects existing ruleset to view/edit
3. Makes modifications to content
4. Saves changes (creates new version)
5. Can revert to previous versions if needed

### **Admin Workflow**
1. Admin user logs in and sees admin toggle in header
2. Switches to admin dashboard view
3. Reviews user list with credit information
4. Grants additional credits to specific users
5. Monitors usage patterns and transaction history
6. Toggles back to wizard for personal use

## 🔒 **Security & Privacy**

### **Data Protection**
- **Environment Variables**: Secure API key management
- **Session Security**: Rails-standard session handling
- **Private Rulesets**: User data isolation and privacy
- **Admin Access**: Environment-based role designation
- **Git Security**: Comprehensive .gitignore with secret exclusions

### **Access Control**
- **Authentication Required**: All features require user login
- **Resource Ownership**: Users can only access their own rulesets
- **Admin Privileges**: Elevated access for user and credit management
- **API Security**: Proper authentication for all endpoints

## 📈 **Success Metrics**

### **User Engagement**
- **Registration Rate**: New user sign-ups per week
- **Generation Success**: Successful ruleset completions
- **Return Usage**: Users creating multiple rulesets
- **Credit Utilization**: Average credits used per user

### **Technical Performance**
- **Generation Speed**: Time from request to completion
- **Error Rate**: Failed generations and system errors
- **Uptime**: Application availability and reliability
- **API Response**: OpenAI and AI Rule Archive integration performance

## 🛣️ **Future Roadmap**

### **Phase 2 Enhancements**
- **Ruleset Sharing**: Public/private sharing with teams
- **Collaboration**: Multi-user editing and commenting
- **Templates**: Pre-built ruleset templates for common scenarios
- **Integrations**: GitHub, GitLab, and IDE plugins

### **Phase 3 Scaling**
- **Credit Packages**: Paid credit tiers and subscriptions
- **Organization Accounts**: Team management and billing
- **Advanced Analytics**: Usage insights and recommendations
- **API Access**: Third-party integrations and developer tools

## 🎨 **Design Principles**

### **User Experience**
- **Simplicity**: Clean, intuitive interface with minimal cognitive load
- **Feedback**: Clear loading states, progress indicators, and error messages
- **Efficiency**: Streamlined workflows with smart defaults
- **Accessibility**: Responsive design with keyboard navigation support

### **Technical Excellence**
- **Reliability**: Robust error handling and graceful degradation
- **Performance**: Fast loading and responsive interactions
- **Maintainability**: Clean code architecture with comprehensive testing
- **Security**: Privacy-first design with secure data handling

## 📋 **MVP Acceptance Criteria**

### **Authentication System**
- ✅ User registration with email/password
- ✅ Login/logout functionality
- ✅ Session management and persistence
- ✅ Admin user designation via environment variables

### **Credit Management**
- ✅ New users receive 10 credits automatically
- ✅ Credit deduction on successful ruleset generation
- ✅ Zero credit handling with disabled generation
- ✅ Admin unlimited credits with usage tracking
- ✅ Credit transaction history and audit trail

### **User Interface**
- ✅ Navigation with login status and credit display
- ✅ User dashboard with recent rulesets and quick actions
- ✅ Admin dashboard with user management and credit controls
- ✅ Admin toggle in header for role switching

### **Ruleset Features**
- ✅ Automatic saving on successful generation
- ✅ Personal library with search and organization
- ✅ Edit functionality with version history
- ✅ Revert capability to previous versions
- ✅ Technology-based tagging system

## 🔧 **Technical Requirements**

### **Environment Setup**
- Ruby 3.2.2+
- Rails 7.2.2.1+
- PostgreSQL 12+
- Node.js for asset compilation
- OpenAI API access
- AI Rule Archive API access

### **Deployment**
- Docker containerization support
- Environment variable configuration
- Database migrations and seeding
- Asset compilation and serving
- CORS configuration for API access

---

**Document Version**: 2.0  
**Last Updated**: July 19, 2025  
**Status**: Implementation Phase  
**Next Review**: Post-MVP Launch