class AddFinalStateToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :final_state, :string
  end
end
