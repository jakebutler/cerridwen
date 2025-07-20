# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_07_20_064932) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "credit_transactions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "amount"
    t.string "transaction_type"
    t.text "description"
    t.bigint "ruleset_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ruleset_id"], name: "index_credit_transactions_on_ruleset_id"
    t.index ["user_id"], name: "index_credit_transactions_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.text "description", null: false
    t.text "tech_stack"
    t.string "dev_identity", null: false
    t.text "requirements_file_content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "updated_at"], name: "index_projects_on_user_id_and_updated_at"
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "rulesets", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.text "content", null: false
    t.integer "version", default: 1, null: false
    t.boolean "is_public", default: false
    t.string "uuid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.text "tags"
    t.bigint "previous_version_id"
    t.index ["is_public"], name: "index_rulesets_on_is_public"
    t.index ["project_id", "version"], name: "index_rulesets_on_project_id_and_version", unique: true
    t.index ["project_id"], name: "index_rulesets_on_project_id"
    t.index ["user_id"], name: "index_rulesets_on_user_id"
    t.index ["uuid"], name: "index_rulesets_on_uuid", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "credits", default: 10, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "credit_transactions", "rulesets"
  add_foreign_key "credit_transactions", "users"
  add_foreign_key "projects", "users"
  add_foreign_key "rulesets", "projects"
  add_foreign_key "rulesets", "users"
end
