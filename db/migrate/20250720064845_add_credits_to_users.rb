class AddCreditsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :credits, :integer, default: 10, null: false
    
    # Set existing users to have 10 credits
    User.update_all(credits: 10)
  end
end
