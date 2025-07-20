class Project < ApplicationRecord
  belongs_to :user, optional: true # Temporarily optional for Active Agent testing
  has_many :rulesets, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true, length: { minimum: 10 }
  validates :dev_identity, presence: true, inclusion: { in: %w[vibe_coder experienced_dev] }

  # Store tech stack as JSON
  serialize :tech_stack, type: Array, coder: JSON

  scope :recent, -> { order(updated_at: :desc) }

  def latest_ruleset
    rulesets.order(version: :desc).first
  end
end
