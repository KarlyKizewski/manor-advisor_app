class AlterCleansAddUserId < ActiveRecord::Migration[5.2]
  def change
    add_column :cleans, :user_id, :integer
    add_index :cleans, :user_id
  end
end
