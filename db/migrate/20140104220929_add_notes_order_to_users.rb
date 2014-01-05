class AddNotesOrderToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notes_order, :string
    add_index :users, :notes_order
    add_column :users, :notes_order_inline, :string
    add_index :users, :notes_order_inline
  end
end
