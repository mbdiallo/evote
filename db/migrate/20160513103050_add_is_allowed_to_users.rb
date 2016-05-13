class AddIsAllowedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_allowed, :boolean, default: false
  end
end
