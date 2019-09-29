class CreateCleans < ActiveRecord::Migration[5.2]
  def change
    create_table :cleans do |t|
      t.string :daily
      t.string :weekly
      t.string :monthly
      t.text :message
      t.timestamps
    end
  end
end
