class CreateSteps < ActiveRecord::Migration
  def change
    create_table :steps do |t|
      t.integer :user_id
      t.datetime :time
      t.integer :period
      t.integer :steps
      t.timestamps
    end
  end
end
