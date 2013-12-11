class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
      t.string :title
      t.integer :duration
      t.text :description

      t.timestamps
    end
  end
end
