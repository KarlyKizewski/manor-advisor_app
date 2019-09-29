class CreateCleans < ActiveRecord::Migration[5.2]
  def change
    create_table :cleans do |t|
      t.string :spring
      t.string :summer
      t.string :fall
      t.string :winter
      t.text :message
      t.timestamps
    end
  end
end
