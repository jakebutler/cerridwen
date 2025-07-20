class Ruleset < ApplicationRecord
  belongs_to :project, optional: true
  belongs_to :user
  belongs_to :previous_version, class_name: 'Ruleset', optional: true
  has_many :newer_versions, class_name: 'Ruleset', foreign_key: 'previous_version_id'
  has_many :credit_transactions, dependent: :destroy

  validates :content, presence: true
  validates :version, presence: true
  validates :uuid, presence: true, uniqueness: true
  validates :user, presence: true

  before_validation :generate_uuid, on: :create
  before_validation :set_version, on: :create
  before_save :extract_tags

  scope :public_rulesets, -> { where(is_public: true) }
  scope :by_version, -> { order(version: :desc) }
  scope :recent, -> { order(created_at: :desc) }
  scope :by_tags, ->(tag_list) { where("tags LIKE ?", "%#{tag_list.join('%')}%") }

  def to_param
    uuid
  end

  def title
    # Extract title from content or use a default
    content_lines = content.split("\n")
    first_header = content_lines.find { |line| line.start_with?('#') }
    first_header&.gsub(/^#+\s*/, '') || "Ruleset #{uuid[0..7]}"
  end

  def word_count
    content.split.size
  end

  def tech_stack_count
    tag_array.size
  end

  def tag_array
    return [] if tags.blank?
    JSON.parse(tags)
  rescue JSON::ParserError
    []
  end

  def tag_array=(new_tags)
    self.tags = new_tags.to_json
  end

  def create_new_version(new_content, user)
    new_version = self.class.create!(
      content: new_content,
      user: user,
      project: project,
      previous_version: self,
      version: self.version + 1
    )
    new_version
  end

  def version_history
    versions = []
    current = self
    while current
      versions << current
      current = current.previous_version
    end
    versions
  end

  def latest_version?
    newer_versions.empty?
  end

  def can_be_edited_by?(user)
    self.user == user
  end

  private

  def generate_uuid
    self.uuid = SecureRandom.uuid if uuid.blank?
  end

  def set_version
    if user.present?
      last_version = user.rulesets.where(project: project).maximum(:version) || 0
      self.version = last_version + 1
    end
  end

  def extract_tags
    return if content.blank?
    
    # Extract technology names from content
    tech_patterns = [
      /\b(ruby|rails|javascript|python|react|vue|angular|node|typescript|java|go|rust|php|laravel|django|flask|express|nextjs|nuxtjs|svelte|alpine)\b/i,
      /\b(postgresql|mysql|mongodb|redis|elasticsearch|docker|kubernetes|aws|gcp|azure|heroku|netlify|vercel)\b/i,
      /\b(html|css|sass|scss|tailwind|bootstrap|jquery|webpack|vite|babel|eslint|prettier|jest|cypress|rspec)\b/i
    ]
    
    found_tags = []
    tech_patterns.each do |pattern|
      matches = content.scan(pattern).flatten.map(&:downcase).uniq
      found_tags.concat(matches)
    end
    
    # Add project tech stack if available
    if project&.tech_stack.present?
      # Handle both string and array formats for tech_stack
      project_tags = if project.tech_stack.is_a?(Array)
        project.tech_stack.map(&:to_s).map(&:strip).map(&:downcase)
      else
        project.tech_stack.split(',').map(&:strip).map(&:downcase)
      end
      found_tags.concat(project_tags)
    end
    
    self.tag_array = found_tags.uniq.sort
  end
end
