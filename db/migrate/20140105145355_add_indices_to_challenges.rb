class AddIndicesToChallenges < ActiveRecord::Migration
  def change
  	add_index :challenges, :user_id
  	add_index :challenges, :final_state
  end
end
