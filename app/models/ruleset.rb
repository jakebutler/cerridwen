class Ruleset < ApplicationRecord
  belongs_to :project

  validates :content, presence: true
  validates :version, presence: true, uniqueness: { scope: :project_id }
  validates :uuid, presence: true, uniqueness: true

  before_validation :generate_uuid, on: :create
  before_validation :set_version, on: :create

  scope :public_rulesets, -> { where(is_public: true) }
  scope :by_version, -> { order(version: :desc) }

  def to_param
    uuid
  end

  private

  def generate_uuid
    self.uuid = SecureRandom.uuid if uuid.blank?
  end

  def set_version
    if project.present?
      last_version = project.rulesets.maximum(:version) || 0
      self.version = last_version + 1
    end
  end
end
