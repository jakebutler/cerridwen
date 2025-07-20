class AddUserAndVersioningToRulesets < ActiveRecord::Migration[7.2]
  def change
    add_reference :rulesets, :user, null: true, foreign_key: true
    add_column :rulesets, :tags, :text
    add_column :rulesets, :previous_version_id, :bigint, null: true
    
    # Set existing rulesets to version 1 (version column already exists)
    # Ruleset.update_all(version: 1) - will run this after migration
  end
end
