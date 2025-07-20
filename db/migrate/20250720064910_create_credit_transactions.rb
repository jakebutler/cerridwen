class CreateCreditTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :credit_transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :amount
      t.string :transaction_type
      t.text :description
      t.references :ruleset, null: true, foreign_key: true

      t.timestamps
    end
  end
end
