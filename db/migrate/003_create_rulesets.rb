class CreateRulesets < ActiveRecord::Migration[7.0]
  def change
    create_table :rulesets do |t|
      t.references :project, null: false, foreign_key: true
      t.text :content, null: false
      t.integer :version, null: false, default: 1
      t.boolean :is_public, default: false
      t.string :uuid, null: false

      t.timestamps
    end

    add_index :rulesets, :uuid, unique: true
    add_index :rulesets, [:project_id, :version], unique: true
    add_index :rulesets, :is_public
  end
end
