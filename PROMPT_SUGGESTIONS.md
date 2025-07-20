### New Prompt Suggestions

Here are some new prompts to test, covering different scenarios and developer personas.

#### Prompt 1: The "Security-Focused" Developer

This prompt is designed for a developer who prioritizes security above all else.

**Persona:** `security_hawk`

**Prompt:**

```
# 🔒 Security-First Rules for #{context[:project_name]}

## Project Overview
#{context[:description]}

## Tech Stack
#{context[:tech_stack].join(', ')}

## Core Principle: Zero Trust
- Trust nothing, verify everything.
- All inputs are considered hostile until proven otherwise.
- Enforce strict access control and least privilege.

## Security Guidelines
- **Input Validation:** Sanitize and validate all user inputs to prevent injection attacks (SQLi, XSS, etc.).
- **Output Encoding:** Encode all output to prevent XSS.
- **Authentication & Authorization:** Use strong password policies, multi-factor authentication, and robust session management.
- **Dependency Management:** Regularly scan for vulnerabilities in third-party libraries and patch them immediately.
- **Secure Defaults:** Configure all services and frameworks with security in mind.

## Tech-Specific Security Rules
#{generate_tech_specific_guidelines(context[:tech_stack], 'secure')}

## Things to Avoid
- Do not use deprecated or insecure functions.
- Do not store secrets in the codebase.
- Do not disable security features for convenience.
```

#### Prompt 2: The "Lean Startup" Developer

This prompt is for a developer working in a fast-paced startup environment where speed and iteration are key.

**Persona:** `lean_innovator`

**Prompt:**

```
# 🚀 Lean & Agile Rules for #{context[:project_name]}

## Project Overview
#{context[:description]}

## Tech Stack
#{context[:tech_stack].join(', ')}

## Guiding Principle: Build, Measure, Learn
- Launch quickly and iterate based on user feedback.
- Focus on delivering value to the user.
- Embrace change and adapt to new requirements.

## Development Practices
- **MVP First:** Build the minimum viable product to test your assumptions.
- **A/B Testing:** Use data to drive decisions and test new features.
- **Continuous Deployment:** Automate your deployment pipeline to ship code faster.
- **User Feedback:** Actively seek and incorporate user feedback.

## Tech-Specific Guidelines
#{generate_tech_specific_guidelines(context[:tech_stack], 'agile')}

## Focus on What Matters
- Don't get bogged down in over-engineering.
- Prioritize features that deliver the most value to the user.
- It's okay to have technical debt, as long as you have a plan to address it.
```

#### Prompt 3: The "Code Quality" Enthusiast

This prompt is for a developer who is passionate about writing clean, maintainable, and well-documented code.

**Persona:** `craftsman_coder`

**Prompt:**

```
# 職人 (Shokunin) Code Crafting Rules for #{context[:project_name]}

## Project Overview
#{context[:description]}

## Tech Stack
#{context[:tech_stack].join(', ')}

## Philosophy: The Art of Code
- Write code that is a joy to read and maintain.
- Take pride in your work and strive for excellence.
- Leave the codebase better than you found it.

## Code Quality Standards
- **Readability:** Write clear, concise, and self-documenting code.
- **Consistency:** Follow a consistent coding style and naming convention.
- **Simplicity:** Choose simplicity over complexity.
- **Testability:** Write code that is easy to test.

## Tech-Specific Craftsmanship
#{generate_tech_specific_guidelines(context[:tech_stack], 'craftsman')}

## The Way of the Craftsman
- Refactor mercilessly to improve code quality.
- Write comprehensive tests to ensure correctness.
- Document your code to share your knowledge.
```
