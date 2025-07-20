class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description, null: false
      t.text :tech_stack
      t.string :dev_identity, null: false
      t.text :requirements_file_content

      t.timestamps
    end

    add_index :projects, [:user_id, :updated_at]
  end
end
